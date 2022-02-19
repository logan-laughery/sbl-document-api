import { buildSchema } from "type-graphql";
import * as path from "path";
import { resolvers } from "../prisma/generated/type-graphql";

export const createSchema = async () =>
  await buildSchema({
    resolvers: [...resolvers],
    emitSchemaFile: path.resolve(__dirname, "./generated-schema.graphql")
  });
