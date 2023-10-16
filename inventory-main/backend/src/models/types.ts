export interface User {
	fname: string;
	lname: string;
	email: string;
	uid: string;
	photoURL: string;
	households: string[]; // list of household ids
	inventory: string; // inventory id
	invitations: string[]; // list of invitation refs
}

export interface Inventory {
	items: Item[];
}

export interface Item {
	name: string;
	quantity: number;
}

export interface Household {
	name: string;
	owner: string;
	inventory: string; // inventory id
	members: string[]; // list of user ids
	outgoingInvitations: string[]; // list of invitation ids
}

export enum InvitationStatus {
	PENDING = "pending",
	ACCEPTED = "accepted",
	DECLINED = "declined",
}

export interface Invitation {
	household: string; // household id
	sender: string; // sender uid
	reciever: string; // reciever uid
	status: InvitationStatus;
}

export interface Recipe {
	name: string;
	ingredients: string[];
	steps: string[];
}
