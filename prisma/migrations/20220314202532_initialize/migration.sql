-- CreateTable
CREATE TABLE "Document" (
    "id" TEXT NOT NULL,
    "sbrId" TEXT NOT NULL,
    "orRequestor" TEXT NOT NULL,
    "orRequestDate" TIMESTAMP(3) NOT NULL,
    "fileName" TEXT NOT NULL,
    "pages" INTEGER NOT NULL,
    "path" TEXT NOT NULL,
    "beginDate" TIMESTAMP(3),
    "endDate" TIMESTAMP(3),
    "relevanceScore" INTEGER,
    "summary" TEXT,
    "driveId" TEXT NOT NULL,

    CONSTRAINT "Document_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmailDetails" (
    "id" TEXT NOT NULL,
    "subject" TEXT NOT NULL,
    "bcc" TEXT,
    "from" TEXT NOT NULL,
    "to" TEXT NOT NULL,
    "cc" TEXT,
    "documentId" TEXT NOT NULL,

    CONSTRAINT "EmailDetails_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DocumentContent" (
    "id" TEXT NOT NULL,
    "text" TEXT NOT NULL,
    "documentId" TEXT NOT NULL,

    CONSTRAINT "DocumentContent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Topic" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Topic_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Personnel" (
    "id" TEXT NOT NULL,
    "firstName" TEXT,
    "lastName" TEXT,
    "email" TEXT,
    "organizationId" TEXT,

    CONSTRAINT "Personnel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Organization" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Organization_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_DocumentToPersonnel" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_DocumentToTopic" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
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
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "_DocumentToPersonnel_AB_unique" ON "_DocumentToPersonnel"("A", "B");

-- CreateIndex
CREATE INDEX "_DocumentToPersonnel_B_index" ON "_DocumentToPersonnel"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_DocumentToTopic_AB_unique" ON "_DocumentToTopic"("A", "B");

-- CreateIndex
CREATE INDEX "_DocumentToTopic_B_index" ON "_DocumentToTopic"("B");

-- AddForeignKey
ALTER TABLE "EmailDetails" ADD CONSTRAINT "EmailDetails_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentContent" ADD CONSTRAINT "DocumentContent_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Personnel" ADD CONSTRAINT "Personnel_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_DocumentToPersonnel" ADD FOREIGN KEY ("A") REFERENCES "Document"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_DocumentToPersonnel" ADD FOREIGN KEY ("B") REFERENCES "Personnel"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_DocumentToTopic" ADD FOREIGN KEY ("A") REFERENCES "Document"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_DocumentToTopic" ADD FOREIGN KEY ("B") REFERENCES "Topic"("id") ON DELETE CASCADE ON UPDATE CASCADE;
