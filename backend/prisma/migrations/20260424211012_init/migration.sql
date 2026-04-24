-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('ORGANIZER', 'ADMIN');

-- CreateEnum
CREATE TYPE "OrganizationType" AS ENUM ('COOPERATIVE', 'INFORMAL_GROUP', 'ASSOCIATION');

-- CreateEnum
CREATE TYPE "PoolStatus" AS ENUM ('OPEN', 'MINIMUM_REACHED', 'PAYMENT_OPEN', 'CLOSED', 'ORDERED', 'DELIVERED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "ReservationStatus" AS ENUM ('RESERVED', 'PAYMENT_PENDING', 'PAID', 'CANCELLED');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "role" "UserRole" NOT NULL DEFAULT 'ORGANIZER',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Organization" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" "OrganizationType" NOT NULL,
    "responsibleName" TEXT NOT NULL,
    "responsiblePhone" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ownerId" TEXT NOT NULL,

    CONSTRAINT "Organization_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Producer" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "wallet" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Producer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BuyingPool" (
    "id" TEXT NOT NULL,
    "productName" TEXT NOT NULL,
    "description" TEXT,
    "supplierName" TEXT,
    "unitPrice" DECIMAL(65,30) NOT NULL,
    "minimumQuantity" INTEGER NOT NULL,
    "currentReservedQuantity" INTEGER NOT NULL DEFAULT 0,
    "deadline" TIMESTAMP(3) NOT NULL,
    "deliveryDate" TIMESTAMP(3),
    "status" "PoolStatus" NOT NULL DEFAULT 'OPEN',
    "solanaPoolAddress" TEXT,
    "creationTxHash" TEXT,
    "organizationId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BuyingPool_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Reservation" (
    "id" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "totalAmount" DECIMAL(65,30) NOT NULL,
    "status" "ReservationStatus" NOT NULL DEFAULT 'RESERVED',
    "paymentReference" TEXT,
    "paymentTxHash" TEXT,
    "blockchainTxHash" TEXT,
    "producerId" TEXT NOT NULL,
    "buyingPoolId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Reservation_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Producer_phone_key" ON "Producer"("phone");

-- AddForeignKey
ALTER TABLE "Organization" ADD CONSTRAINT "Organization_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BuyingPool" ADD CONSTRAINT "BuyingPool_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reservation" ADD CONSTRAINT "Reservation_producerId_fkey" FOREIGN KEY ("producerId") REFERENCES "Producer"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reservation" ADD CONSTRAINT "Reservation_buyingPoolId_fkey" FOREIGN KEY ("buyingPoolId") REFERENCES "BuyingPool"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
