import { Request, Response } from "express";
import { getInventory, setInventoryItems } from "./inventory";
import { createUser, getAllUsers, getUser, updateUser, userExists } from "./user";
import {
	createHousehold,
	getHousehold,
	getHouseholds,
	inviteToHousehold,
	deleteUser,
	setMembers,
} from "./household";
import { getInvitations, updateInvitation } from "./invitation";
import { generateRecipes } from "./recipe";

export interface Route {
	route: string;
	method: "get" | "post" | "put" | "delete";
	handler: (req: Request, res: Response) => void;
}

export const routes = [
	getAllUsers,
	getUser,
	createUser,
	getInventory,
	setInventoryItems,
	createHousehold,
	getHousehold,
	getHouseholds,
	userExists,
	inviteToHousehold,
	deleteUser,
	getInvitations,
	updateInvitation,
	generateRecipes,
	setMembers,
	updateUser,
];
