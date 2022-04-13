import { buildSchema } from "type-graphql";
import * as path from "path";
// import { resolvers } from "../prisma/generated/type-graphql";
import {
  FindUniqueDocumentResolver,
  FindManyDocumentResolver,
  relationResolvers
} from "../prisma/generated/type-graphql";
import {resolvers as documentResolvers} from "./resolvers/Documents";

export const createSchema = async () =>
  await buildSchema({
    resolvers: [
      FindUniqueDocumentResolver,
      FindManyDocumentResolver,
      ...relationResolvers,
      ...documentResolvers
    ],
    // emitSchemaFile: path.resolve(__dirname, "./generated-schema.graphql")
  });
