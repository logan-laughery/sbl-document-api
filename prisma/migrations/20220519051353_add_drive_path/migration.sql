-- AlterTable
ALTER TABLE "Document" ADD COLUMN     "driveFilePath" TEXT,
ALTER COLUMN "driveId" DROP NOT NULL;
