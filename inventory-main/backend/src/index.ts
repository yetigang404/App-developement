import express, { Express } from "express";
import { routes } from "./routes/route";
import cors from "cors";

import * as dotenv from "dotenv";
dotenv.config();

const app: Express = express();
app.use(express.json());
app.use(cors());
const port = 8080;

for (const route of routes) {
	const handler = route.handler;
	const url = route.route;

	switch (route.method) {
		case "get":
			app.get(url, handler);
			break;
		case "post":
			app.post(url, handler);
			break;
		case "put":
			app.put(url, handler);
			break;
		case "delete":
			app.delete(url, handler);
			break;
	}
}

app.listen(port, () => {
	console.log(`️[server]: Server is running at http://localhost:${port}`);
});
