/*
  Warnings:

  - You are about to drop the `Post` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "Post";
PRAGMA foreign_keys=on;

-- CreateTable
CREATE TABLE "Document" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "sbrId" TEXT NOT NULL,
    "orRequestor" TEXT NOT NULL,
    "orRequestDate" DATETIME NOT NULL,
    "fileName" TEXT NOT NULL,
    "pages" INTEGER NOT NULL,
    "path" TEXT NOT NULL,
    "beginDate" DATETIME,
    "endDate" DATETIME,
    "relevanceScore" INTEGER,
    "driveId" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "EmailDetails" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "subject" TEXT NOT NULL,
    "bcc" TEXT,
    "from" TEXT NOT NULL,
    "to" TEXT NOT NULL,
    "cc" TEXT,
    "documentId" TEXT NOT NULL,
    CONSTRAINT "EmailDetails_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "DocumentContent" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "text" TEXT NOT NULL,
    "documentId" TEXT NOT NULL,
    CONSTRAINT "DocumentContent_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Topic" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "Personnel" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "firstName" TEXT,
    "lastName" TEXT,
    "email" TEXT,
    "organizationId" TEXT,
    CONSTRAINT "Personnel_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Organization" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_DocumentToPersonnel" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,
    FOREIGN KEY ("A") REFERENCES "Document" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY ("B") REFERENCES "Personnel" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "_DocumentToTopic" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,
    FOREIGN KEY ("A") REFERENCES "Document" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY ("B") REFERENCES "Topic" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "Document_sbrId_key" ON "Document"("sbrId");

-- CreateIndex
CREATE UNIQUE INDEX "EmailDetails_documentId_key" ON "EmailDetails"("documentId");

-- CreateIndex
CREATE UNIQUE INDEX "DocumentContent_documentId_key" ON "DocumentContent"("documentId");

-- CreateIndex
CREATE UNIQUE INDEX "Topic_name_key" ON "Topic"("name");

-- CreateIndex
CREATE UNIQUE INDEX "_DocumentToPersonnel_AB_unique" ON "_DocumentToPersonnel"("A", "B");

-- CreateIndex
CREATE INDEX "_DocumentToPersonnel_B_index" ON "_DocumentToPersonnel"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_DocumentToTopic_AB_unique" ON "_DocumentToTopic"("A", "B");

-- CreateIndex
CREATE INDEX "_DocumentToTopic_B_index" ON "_DocumentToTopic"("B");
