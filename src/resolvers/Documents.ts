import { NonEmptyArray, Resolver, Query, Ctx, Info, Args, Field, Int, ObjectType, ArgsType } from "type-graphql";
import { Document, FindManyDocumentArgs, DocumentOrderByWithRelationInput } from "../../prisma/generated/type-graphql";
import { GraphQLResolveInfo } from "graphql";

const tsquerySpecialChars = /[()|&:*!]/g;

const getQueryFromSearchPhrase = (searchPhrase: string) =>
  searchPhrase
    .replace(tsquerySpecialChars, " ")
    .trim()
    .split(/\s+/)
    .join(" | ");

@ObjectType({
  isAbstract: true
})
class DocumentSearchCountResult {
  @Field(_type => String, {
    nullable: false
  })
  count: number;
}

@ObjectType({
  isAbstract: true
})
class DocumentSearchResult extends Document {
  @Field(_type => String, {
    nullable: true
  })
  match?: string | null;
}

@ArgsType()
class DocumentSearchArgs {
  @Field(_type => [DocumentOrderByWithRelationInput], {
    nullable: true
  })
  orderBy?: DocumentOrderByWithRelationInput[] | undefined;

  @Field(_type => Int, {
    nullable: false
  })
  take?: number;

  @Field(_type => Int, {
    nullable: false
  })
  skip: number;

  @Field(_type => String, {
    nullable: true
  })
  search?: string | null;
}

@ArgsType()
class DocumentSearchCountArgs {
  @Field(_type => String, {
    nullable: true
  })
  search?: string | null;
}
 
  
@Resolver()
class CustomDocumentResolver {
  @Query(returns => [DocumentSearchResult], { nullable: false })
  async searchDocuments(@Ctx() { prisma }: any, @Info() info: GraphQLResolveInfo, @Args() args: DocumentSearchArgs): Promise<DocumentSearchResult[]> {
    const {search, ...prismaArgs} = args;
    
    if (!search) {
      return prisma.document.findMany({
        ...prismaArgs
      });
    }

    const query = getQueryFromSearchPhrase(search);
    const manualOrderBy = Object.keys(prismaArgs.orderBy[0]).map(key => 
      `a."${key}" ${prismaArgs.orderBy[0][key] ? 'ASC' : 'DESC'}`
    );

    const result = await prisma.$queryRaw`
      SELECT a.id, ts_headline('english', b."text", to_tsquery('english', ${query})) as match, "sbrId", 
        "orRequestor", "orRequestDate", "fileName", pages, path, "beginDate", "endDate", "relevanceScore", summary, "driveId"
      FROM public."Document" a
      JOIN public."DocumentContent" b
        ON a.id = b."documentId"
      WHERE b."textSearch" @@ to_tsquery('english', ${query})
      ORDER BY 
        ts_rank(b."textSearch", to_tsquery('english', ${query})) DESC,${manualOrderBy.join(',')}
      LIMIT ${args.take}
      OFFSET ${args.skip};
    `;

    return result.map(row => ({
      ...row,
      orRequestDate: new Date(row.orRequestDate)
    }));
  }

  @Query(returns => DocumentSearchCountResult, { nullable: false })
  async searchDocumentsCount(@Ctx() { prisma }: any, @Info() info: GraphQLResolveInfo, @Args() args: DocumentSearchCountArgs): Promise<DocumentSearchCountResult> {
    const {search, ...prismaArgs} = args;
    
    if (!search) {
      const result = await prisma.document.count({
        ...prismaArgs
      });

      return {
        count: result
      };
    }

    const query = getQueryFromSearchPhrase(search);

    const result = await prisma.$queryRaw`
      SELECT count(*)
      FROM public."Document" a
      JOIN public."DocumentContent" b
        ON a.id = b."documentId"
      WHERE b."textSearch" @@ to_tsquery('english', ${query});
    `;

    return result[0];
  }
}

export const resolvers = [
    CustomDocumentResolver
] as unknown as NonEmptyArray<Function>;