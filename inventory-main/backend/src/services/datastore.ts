import { Datastore, PropertyFilter } from "@google-cloud/datastore";
import {
	User,
	Inventory,
	Item,
	Household,
	Invitation,
	InvitationStatus,
} from "../models/types";

export class DataStoreService {
	private datastore: Datastore;
	private static _instance?: DataStoreService;

	private constructor() {
		this.datastore = new Datastore();
	}

	public static get instance(): DataStoreService {
		if (!this._instance) {
			this._instance = new DataStoreService();
		}

		return this._instance;
	}

	private static set instance(s: DataStoreService) {
		this._instance = s;
	}

	public async getUsers(): Promise<User[]> {
		const query = this.datastore.createQuery("User");
		const [users] = await this.datastore.runQuery(query);
		return users as User[];
	}

	public async getUser(uid: string): Promise<User> {
		const key = this.datastore.key(["User", uid]);
		const [user]: User[] = await this.datastore.get(key);
		if (!user) {
			throw new Error("User not found");
		}
		return user;
	}

	public async createUser(user: User): Promise<void> {
		const userKey = this.datastore.key(["User", user.uid]);

		const userInventory = await this.createInventory();
		user.inventory = userInventory;

		const newUser = {
			key: userKey,
			data: user,
		};

		try {
			await this.datastore.save(newUser);
		} catch (e) {
			throw new Error("could not create user");
		}
	}

	public async createInventory(): Promise<string> {
		const newInventory: Inventory = { items: [] };

		const inventoryKey = this.datastore.key("Inventory");
		await this.datastore.save({
			key: inventoryKey,
			data: newInventory,
		});

		return inventoryKey.id!;
	}
	public async createHousehold(household: Household): Promise<String> {
		const inventory_id = await this.createInventory();
		household.inventory = inventory_id;
		const householdKey = this.datastore.key("Household");
		await this.datastore.save({
			key: householdKey,
			data: household,
		});
		const user = await this.getUser(household.owner);
		user.households.push(householdKey.id!);
		await this.setUser(user);
		return householdKey.id!;
	}

	public async getInventory(id: string): Promise<Inventory> {
		const key = this.datastore.key(["Inventory", this.datastore.int(id)]);
		const [inventory] = await this.datastore.get(key);
		if (!inventory) {
			throw Error("inventory not found");
		}
		return inventory as Inventory;
	}

	public async setInventoryItems(id: string, items: Item[]): Promise<void> {
		const inventory = await this.getInventory(id);
		inventory.items = items;
		await this.datastore.save({
			key: this.datastore.key(["Inventory", this.datastore.int(id)]),
			data: inventory,
		});
	}

	public async getHousehold(id: string): Promise<Household> {
		const key = this.datastore.key(["Household", this.datastore.int(id)]);
		const [household] = await this.datastore.get(key);
		if (!household) {
			throw Error("Household not found");
		}
		return household as Household;
	}

	public async inviteUsersToHousehold(
		householdId: string,
		sender: string,
		ids: string[]
	) {
		const invitations: Invitation[] = [];
		for (const id of ids) {
			const invitation: Invitation = {
				household: householdId,
				reciever: id,
				sender: sender,
				status: InvitationStatus.PENDING,
			};
			invitations.push(invitation);
		}
		await this.createInvitations(invitations);
	}

	public async createInvitations(invitations: Invitation[]): Promise<void> {
		if (invitations.length == 0) {
			return;
		}
		const household = await this.getHousehold(invitations[0].household);

		for (const invitation of invitations) {
			const key = this.datastore.key("Invitation");
			await this.datastore.save({
				key: key,
				data: invitation,
			});

			const reciever = await this.getUser(invitation.reciever);
			reciever.invitations.push(key.id!);

			household.outgoingInvitations.push(key.id!);

			await this.setUser(reciever);
		}
		await this.setHousehold(invitations[0].household, household);
	}

	public async getInvitation(invitationId: string): Promise<Invitation> {
		const key = this.datastore.key([
			"Invitation",
			this.datastore.int(invitationId),
		]);
		const [invitation] = await this.datastore.get(key);
		if (!invitation) {
			throw Error("Invitation not found");
		}
		return invitation as Invitation;
	}

	public async setUser(user: User): Promise<void> {
		await this.datastore.save(user);
	}

	public async setHousehold(id: string, data: Household): Promise<void> {
		const key = this.datastore.key(["Household", this.datastore.int(id)]);
		await this.datastore.save(data);
	}

	public async userExists(email: string): Promise<User | null> {
		const emailFilter = new PropertyFilter("email", "=", email);
		const query = this.datastore
			.createQuery("User")
			.filter(emailFilter)
			.limit(1);
		const [users] = await this.datastore.runQuery(query);
		if (users.length > 0) {
			return users[0];
		} else {
			return null;
		}
	}
	public async deleteUser(id: string, hid: string): Promise<void> {
		const a = await this.getUser(id);
		const index = a.households.indexOf(hid, 0);
		a.households.splice(index, 1);
		await this.setUser(a);
	}
	public async deleteHousehold(id: string, hid: string): Promise<void> {
		const a = await this.getHousehold(hid);
		const index = a.members.indexOf(id, 0);
		a.members.splice(index, 1);
		await this.setHousehold(hid, a);
	}

	private async setInvitation(id: string, data: Invitation): Promise<void> {
		const key = this.datastore.key(["Invitation", this.datastore.int(id)]);
		await this.datastore.save(data);
	}

	public async declineInvitation(invitationId: string) {
		// remove invitation from user, and mark invitation as declined
		const invitation = await this.getInvitation(invitationId);
		const user = await this.getUser(invitation.reciever);
		const index = user.invitations.indexOf(invitationId, 0);
		user.invitations.splice(index, 1);
		await this.setUser(user);

		await this.datastore.delete(
			this.datastore.key([
				"Invitation",
				this.datastore.int(invitationId),
			])
		);
	}
	public async acceptInvitation(invitationId: string) {
		// add user to household, remove invitation from user, and mark invitation as accepted and delete invitation
		const invitation = await this.getInvitation(invitationId);
		const user = await this.getUser(invitation.reciever);
		const index = user.invitations.indexOf(invitationId, 0);
		user.invitations.splice(index, 1);

		const household = await this.getHousehold(invitation.household);
		household.members.push(invitation.reciever);
		await this.setHousehold(invitation.household, household);

		user.households.push(invitation.household);
		await this.setUser(user);

		await this.datastore.delete(
			this.datastore.key([
				"Invitation",
				this.datastore.int(invitationId),
			])
		);
	}
}
