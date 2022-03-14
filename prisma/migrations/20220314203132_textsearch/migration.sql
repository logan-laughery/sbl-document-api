/*
  Warnings:

  - You are about to drop the column `text` on the `DocumentContent` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "DocumentContent" DROP COLUMN "text",
ADD COLUMN     "textSearch" TSVECTOR;

-- CreateIndex
CREATE INDEX "DocumentContent_textSearch_idx" ON "DocumentContent" USING GIN ("textSearch");
