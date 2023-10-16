import { TextServiceClient } from "@google-ai/generativelanguage";
import { GoogleAuth } from "google-auth-library";
import { Recipe } from "../models/types";

export class PalmService {
	static MODEL_NAME = "models/text-bison-001";

	private static _instance?: PalmService;

	private client: TextServiceClient;

	private constructor() {
		const api_key = process.env.PALM_API_KEY!;
		this.client = new TextServiceClient({
			authClient: new GoogleAuth().fromAPIKey(api_key),
		});
	}

	public static get instance(): PalmService {
		if (!PalmService._instance) {
			PalmService._instance = new PalmService();
		}
		return PalmService._instance;
	}

	public async generateRecipes(ingredients: string[]): Promise<Recipe[]> {
		// const prompt_string =
		// 	"Based on the list of ingredients that are in a kitchen, generate some recipes that use the ingredients given. Assume there are already common kitchen ingredients and spices such as salt, pepper, milk, eggs, sugar, oil, butter etc. \ninput: Milk, Eggs, Chicken Breast, Ground Beef, carrots, tomatoes, garlic, ginger, honey, celery, vegetable stock, pasta, marinara sauce, cream, frozen shrimp, hot dogs, pickles, Parmesan, flour, panko, brown rice, soy sauce, green onions.\noutput: - Chicken Parm\n-- Ingredients: Chicken Breast, Pasta, Flour, Parmesan, marinera sauce, salt, pepper, oregano, basil\n-- Steps: \n1) Beat chicken using a meat mallet.\n2) Season chicken with salt and pepper. Sprinkle some flour evenly on both sides.\n3) Beat eggs and place them aside\n4) Mix panko and Parmesan in a bowl and set aside.\n5) Dip chicken into eggs, and then into panko-Parmesan bowl.\n6) Heat an oiled skillet and cook chicken\n7) Transfer chicken to baking dish, and cover with marinara and more cheese\n8) Bake in a oven until cheese is browned and bubbly and chicken breasts are no longer pink in the center.\n9) Boil pasta\n10) Serve with pasta, marinara sauce, and cooked chicken.\n-----\n- Chicken and Egg fried rice\n-- Ingredients: Chicken Breast, vegetable stock, brown rice, soy sauce, green onions\n-- Steps:\n1) Cook rice.\n2) Heat an oiled wok or large pan on medium heat\n3) Crack eggs into wok, and scramble\n4) Add in diced chicken\n5) Lightly add spices\n6) Once both are cooked, add in rice and stir\n7) Add in some stock if desired. Also add some soy sauce\n8) Stir and cook until done.\n9) Serve with chopped green onion.\ninput:";
		// const response = await this.client.generateText({
		// 	// required, which model to use to generate the result
		// 	model: PalmService.MODEL_NAME,
		// 	// optional, 0.0 always uses the highest-probability result
		// 	temperature: 0.75,
		// 	// optional, how many candidate results to generate
		// 	candidateCount: 1,
		// 	// optional, number of most probable tokens to consider for generation
		// 	topK: 40,
		// 	// optional, for nucleus sampling decoding strategy
		// 	topP: 0.95,
		// 	prompt: {
		// 		text: prompt_string + ingredients.join(", ") + "\n",
		// 	},
		// });
		// return this.parseRecipes(response[0].candidates![0].output!);

		return this.parseRecipes(
			"output: - Tuna melt\n-- Ingredients: Tuna, bread, cheese, mayo, mustard, tomato, lettuce\n-- Steps:\n1) Mix canned tuna with mayo and mustard.\n2) Toast bread.\n3) Spread tuna mixture on bread.\n4) Top with cheese, tomato and lettuce.\n5) Heat in a panini press until cheese is melted.\n-----\n- Pesto pasta\n-- Ingredients: Pesto sauce, pasta, shrimp\n-- Steps:\n1) Cook pasta according to package directions.\n2) While pasta is cooking, heat some pesto sauce in a large skillet.\n3) Add shrimp to the skillet and cook until pink.\n4) Add cooked pasta to the skillet and stir to coat.\n5) Serve immediately.\n-----\n- Chocolate chip cookies\n-- Ingredients: Flour, baking soda, salt, butter, sugar, eggs, vanilla, chocolate chips\n-- Steps:\n1) Preheat oven to 375 degrees Fahrenheit.\n2) Line a baking sheet with parchment paper.\n3) In a medium bowl, whisk together the flour, baking soda, and salt.\n4) In a large bowl, cream together the butter and sugar until light and fluffy.\n5) Beat in the eggs one at a time, then stir in the vanilla.\n6) Gradually add the dry ingredients to the wet ingredients, mixing until just combined.\n7) Fold in the chocolate chips.\n8) Drop the dough by rounded tablespoons onto the prepared baking sheet, spacing them about 2 inches apart.\n9) Bake for 10-12 minutes, or until the edges are golden brown and the centers are set.\n10) Let cool on the baking sheet for a few minutes before transferring to a wire rack to cool completely.\n-----\n- Shrimp scampi\n-- Ingredients: Shrimp, butter, garlic, lemon, parsley, white wine\n-- Steps:\n1) Peel and devein shrimp.\n2) Heat some butter in a large skillet over medium heat.\n3) Add shrimp and cook until pink.\n4) Add garlic and cook for 1 minute more.\n5) Add lemon juice and white wine and cook until reduced by half.\n6) Stir in parsley and serve immediately.\n-----\n- Spring salad\n-- Ingredients: Arugula, kale, carrots, celery, tomatoes, onions, olive oil, lemon, salt, pepper\n-- Steps:\n1) Wash and dry the greens.\n2) Cut the vegetables into small pieces.\n3) In a large bowl, combine the greens, vegetables, olive oil, lemon juice, salt, and pepper.\n4) Toss to coat.\n5) Serve immediately."
		);
	}

	private parseRecipes(output: string): Recipe[] {
		const recipes: Recipe[] = [];
		output = output.replace("output: - ", "");

		const recipeStrings = output.split("-----");
		for (const recipeString of recipeStrings) {
			const recipe = this.parseRecipe(recipeString);
			recipes.push(recipe);
		}
		return recipes;
	}

	parseRecipe(recipeString: string): Recipe {
		if (recipeString[0] == "\n") {
			recipeString = recipeString.substring(3);
		}
		const name = recipeString.split("\n")[0].replace("- ", "");
		const ingredients = recipeString
			.split("-- Ingredients: ")[1]
			.split("\n")[0]
			.split(", ");
		const steps = recipeString
			.split("-- Steps:")[1]
			.split("\n")
			.map((step) => step.trim())
			.filter((step) => step.length > 0);

		return {
			name: name,
			ingredients: ingredients,
			steps: steps,
		};
	}
}
