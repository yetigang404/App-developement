import { PalmService } from "../services/palm";
import { Route } from "./route";

export const generateRecipes: Route = {
	route: "/generate_recipes",
	method: "post",
	async handler(req, res) {
		const ingredients: string[] = req.body;
		const recipes = await PalmService.instance.generateRecipes(ingredients);
		res.status(200).send(recipes);
	},
};
