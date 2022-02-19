import "reflect-metadata";
import express from "express";
import { ApolloServer } from "apollo-server-express";
import { PrismaClient } from "@prisma/client";

import { createSchema } from "./createSchema";
import { serverURL, serverPORT } from "../config/default";
// tslint:disable-next-line
require("dotenv").config();

interface Context {
  prisma: PrismaClient;
}

const startServer = async () => {
  const prisma = new PrismaClient();
  await prisma.$connect();

  const schema = await createSchema();

  const app = express();

  const server = new ApolloServer({
    schema,
    context: (): Context => ({ prisma }),
  });

  await server.start();

  server.applyMiddleware({
    app,
    path: "/",
    cors: {
      "origin": "https://studio.apollographql.com",
      "credentials": true
    },
  });

  app.listen({ port: serverPORT }, () =>
    console.log(`🚀 Server is starting on ${serverURL}${server.graphqlPath} ..`)
  );
};

startServer().catch(error => {
  console.error(error);
});
