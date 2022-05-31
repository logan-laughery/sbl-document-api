import "reflect-metadata";
import express from "express";
import cors from 'cors';
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
  const fileReaderClient = new PrismaClient();

  await fileReaderClient.$connect();
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
    path: "/graphql",
    cors: {
      "origin": true,
      "credentials": true
    },
  });

  app.get('/documentFile/:id', cors(), async (req, res) => {
    const documentId = req.params.id;

    const documentContent = await fileReaderClient.documentContent.findUnique({
      where: {
        documentId,
      },
    });

    res.send(documentContent.file);
  });

  app.listen({ port: serverPORT }, () =>
    console.log(`🚀 Server is starting on ${serverURL}${server.graphqlPath} ..`)
  );
};

startServer().catch(error => {
  console.error(error);
});
