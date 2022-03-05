import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

async function main() {
  await prisma.$connect();

  await prisma.documentContent.deleteMany({});
  await prisma.emailDetails.deleteMany({});
  await prisma.personnel.deleteMany({});
  await prisma.document.deleteMany({});

  const document1 = await prisma.document.create({
      data: {
          sbrId: "A01",
          orRequestor: "Logan Laughery",
          orRequestDate: new Date(),
          fileName: "Test.pdf",
          pages: 1,
          path: "test/Test.pdf",
          driveId: "tjklsflkjsfljsfl",
          personnel: {
              create: [
                  {
                      firstName: "Logan",
                      lastName: "Laughery",
                      email: "test@email.com"
                  }
              ]
          },
          emailDetails: {
              create: {
                  subject: "Test Email",
                  from: "test@email.com",
                  to: "test@email.com"
              }
          },
          documentContent: {
            create: {
                text: "This is a test message"
            }
          }
      }
  });

  console.log({ document1 });
//   await prisma.post.deleteMany({});
//   await prisma.user.deleteMany({});

//   const user1 = await prisma.user.create({
//     data: {
//       email: "alice@prisma.io",
//       name: "Alice",
//       posts: {
//         create: [
//           {
//             title: "Join us for Prisma Day 2019 in Berlin",
//             content: "https://www.prisma.io/day/",
//             published: true,
//           },
//           {
//             title: "Join us for Prisma Day 2020 in Berlin",
//             content: "https://www.prisma.io/day/",
//             published: false,
//           },
//         ],
//       },
//     },
//   });
//   const user2 = await prisma.user.create({
//     data: {
//       email: "bob@prisma.io",
//       name: "Bob",
//       posts: {
//         create: [
//           {
//             title: "Subscribe to GraphQL Weekly for community news",
//             content: "https://graphqlweekly.com/",
//             published: true,
//           },
//           {
//             title: "Follow Prisma on Twitter",
//             content: "https://twitter.com/prisma",
//             published: false,
//           },
//         ],
//       },
//     },
//   });

//   console.log({ user1, user2 });
}

main()
  .catch(e => console.error(e))
  .finally(async () => {
    await prisma.$disconnect();
  });