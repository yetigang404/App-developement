import { Invitation, InvitationStatus } from "../models/types";
import { DataStoreService } from "../services/datastore";
import { Route } from "./route";

export const getInvitations: Route = {
	route: "/getInvitations",
	method: "post",
	async handler(req, res) {
		const invitationIds: string[] = req.body;
		const invitations: Invitation[] = [];
		for (const invitationId of invitationIds) {
			const invitation = await DataStoreService.instance.getInvitation(
				invitationId
			);
			invitations.push(invitation);
		}
		res.json(invitations).status(200).send();
	},
};

export const updateInvitation: Route = {
	route: "/invitations/:id/update",
	method: "post",
	async handler(req, res) {
		const n_status: InvitationStatus = req.body.status;
		const invitationId = req.params.id;

		switch (n_status) {
			case InvitationStatus.ACCEPTED:
				await DataStoreService.instance.acceptInvitation(invitationId);
				break;
			case InvitationStatus.DECLINED:
				await DataStoreService.instance.declineInvitation(invitationId);
				break;
		}

		res.status(200).send();
	},
};
