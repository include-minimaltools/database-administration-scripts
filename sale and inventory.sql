/*
USE MASTER
GO
DROP DATABASE [Sale and Inventory]

*/

CREATE DATABASE [Sale and Inventory]
GO
USE [Sale and Inventory]
GO

CREATE TABLE Customer(
    CustomerId varchar(20) COLLATE Modern_Spanish_CI_AS NOT NULL,
    Firstname varchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
    Lastname varchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
    Phone varchar(20) COLLATE Modern_Spanish_CI_AS NOT NULL,
    Address varchar(250) COLLATE Modern_Spanish_CI_AS NOT NULL,
    CreditLimit float NOT NULL,
    TotalCredit float NOT NULL,
    Photo varchar(250) NOT NULL,
    CONSTRAINT PKCustomerId PRIMARY KEY (CustomerId)   
)
GO

CREATE TABLE Payment(
    PaymentId varchar(20) COLLATE Modern_Spanish_CI_AS NOT NULL,
    CustomerId varchar(20) COLLATE Modern_Spanish_CI_AS NOT NULL,
    Payment float NOT NULL,
    PaymentDate datetime NOT NULL,
    CONSTRAINT PKPaymentId PRIMARY KEY (PaymentId),
    CONSTRAINT FKCustomerId FOREIGN KEY (CustomerId) REFERENCES Customer
)
GO

CREATE TABLE Supplier(
    SupplierId varchar(20),
    CompanyName varchar(100),
    Address varchar(150),
    Phone varchar(20),
    CONSTRAINT PKSupplierId PRIMARY KEY (SupplierId)
)
GO

CREATE TABLE Sale(
    SaleId varchar(20),
    SupplierId varchar(20),
    SaleDate datetime,
    TotalSale float, 
    Discount float, 
    Tax float,
    GrandTotal float,
    CONSTRAINT PKSaleId PRIMARY KEY (SaleId),
    CONSTRAINT FKSupplierId FOREIGN KEY (SupplierId) REFERENCES Supplier
)
GO

CREATE TABLE Product(
    ProductId varchar(20),
    CategoryId varchar(20),
    Product varchar(200),
    UnitMeasure varchar(20),
    UnitPrice float, 
    Stock float, 
    InventoryType varchar(20),
    CONSTRAINT PKProductId PRIMARY KEY (ProductId)
)
GO

CREATE TABLE SaleDetail(
    SaleId varchar(20),
    ProductId varchar(20),
    Stock float, 
    UnitCost float,
    SubTotal float, 
    CONSTRAINT FKSaleId FOREIGN KEY (SaleId) REFERENCES Sale,
    CONSTRAINT FKProductId FOREIGN KEY (ProductId) REFERENCES Product
)
GO

CREATE TABLE Invoice(
    InvoiceId varchar(20) COLLATE Modern_Spanish_CI_AS NOT NULL,
    CustomerId varchar(20) COLLATE Modern_Spanish_CI_AS NOT NULL,
    SaleType varchar(20) COLLATE Modern_Spanish_CI_AS NOT NULL,
    InvoiceDate datetime NOT NULL,
    TotalInvoice float  NULL,
    Time varchar(10) COLLATE Modern_Spanish_CI_AS NULL,
    Active bit NULL,
    CONSTRAINT PKInvoiceId PRIMARY KEY (InvoiceId),
    CONSTRAINT FKInvoiceCustomerId FOREIGN KEY (CustomerId) REFERENCES Customer
)
GO

CREATE TABLE InvoiceDetail(
    InvoiceId varchar(20) COLLATE Modern_Spanish_CI_AS NOT NULL,
    ProductId varchar(20) NOT NULL,
    Stock float NOT NULL,
    SubTotal float NOT NULL,
    CONSTRAINT FKInvoiceDetailInvoiceId FOREIGN KEY (InvoiceId) REFERENCES Invoice,
    CONSTRAINT FKInvoiceDetailProductId FOREIGN KEY (ProductId) REFERENCES Product
)
GO

/*Modifications to tables*/

/*ALTER TABLE Payment WITH NOCHECK ADD
    CONSTRAINT PK_Payment PRIMARY KEY CLUSTERED(Id)
GO*/

ALTER TABLE Customer WITH NOCHECK ADD 
    CONSTRAINT Customer_Phone DEFAULT('N/A') FOR Phone,
    CONSTRAINT Customer_CreditLimit DEFAULT(0) FOR CreditLimit,
    CONSTRAINT Customer_TotalCredit DEFAULT(0) FOR TotalCredit
GO

ALTER TABLE Customer
ALTER COLUMN Photo Varchar (100) NULL
GO

ALTER TABLE Sale WITH NOCHECK ADD
CONSTRAINT Sale_TotalInvoice DEFAULT(0)FOR TotalSale,
CONSTRAINT Sale_Discount DEFAULT(0)FOR Discount,
CONSTRAINT Sale_Tax DEFAULT(0)FOR Tax,
CONSTRAINT Sale_GrandTotal DEFAULT(0)FOR GrandTotal
GO

Use [Sale and Inventory]
Go

--/Stored Procedures Creation/

--INSERT

CREATE PROCEDURE SP_InsertCustomer
@CustomerId varchar(20),
@FirstName Varchar(50),
@LastName varchar(50),
@Phone varchar(20),
@Address varchar(250),
@TotalCredit float,
@CreditLimit float
--@photo varchar(250) NULL
AS
Begin
Insert into Customer
(CustomerId, FirstName, LastName, Phone, Address, TotalCredit,CreditLimit)
Values (@CustomerId, @FirstName, @LastName, @Phone, @Address, @TotalCredit, @CreditLimit)
End
Go

CREATE PROCEDURE SP_InsertSupplier
@SupplierId varchar(20),
@CompanyName varchar(100),
@Address varchar(150),
@Phone varchar(20)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Supplier (SupplierId, CompanyName, Address, Phone)
    VALUES (@SupplierId, @CompanyName, @Address, @Phone);
END
GO


CREATE PROCEDURE SP_InsertProduct
@ProductId varchar(20),
@CategoryId varchar(20),
@Product varchar(20),
@UnitMeasure varchar(20),
@UnitPrice float,
@Stock float,
@InventoryType varchar(20)
AS
Begin
INSERT Into Product
(ProductId, CategoryId, Product, UnitMeasure, UnitPrice, Stock, InventoryType)
VALUES (@ProductId, @CategoryId, @Product, @UnitMeasure, @UnitPrice, @Stock, @InventoryType)
End
GO

CREATE PROCEDURE SP_InsertSale
@SaleId Varchar(20),
@SupplierId Varchar(20),
@SaleDate datetime,
@TotalSale Float,
@Discount Float,
@Tax Float,
@GrandTotal Float
AS
Begin
INSERT Into Sale
(SaleId, SupplierId, SaleDate, TotalSale, Discount, Tax, GrandTotal)
VALUES (@SaleId, @SupplierId, @SaleDate, @TotalSale, @Discount, @Tax, @GrandTotal)
End
GO

CREATE PROCEDURE SP_InsertSaleDetail
@SaleId Varchar(20),
@ProductId Varchar(20),
@Stock Float,
@UnitCost Float,
@SubTotal Float
AS
Begin
INSERT Into SaleDetail
(SaleId, ProductId, Stock, UnitCost, SubTotal)
VALUES (@SaleId, @ProductId, @Stock, @UnitCost, @SubTotal)
End
GO

CREATE PROCEDURE SP_InsertInvoice
@InvoiceId varchar (20),
@CustomerId varchar(20),
@SaleType Varchar(20),
@InvoiceDate datetime,
@TotalInvoice float,
@Time varchar(10),
@active bit
AS
Begin
Insert into Invoice
(InvoiceId,CustomerId,SaleType,InvoiceDate,TotalInvoice,Time,active)
Values (@InvoiceId,@CustomerId,@SaleType,@InvoiceDate,@TotalInvoice,@Time,@active)
End
Go

CREATE PROCEDURE SP_InsertInvoiceDetail
@InvoiceId Varchar(20),
@ProductId Varchar(20),
@Stock Float,
@SubTotal Float
AS
Begin
INSERT Into InvoiceDetail
(InvoiceId, ProductId, Stock, SubTotal)
VALUES (@InvoiceId, @ProductId, @Stock, @SubTotal)
End
GO

CREATE PROCEDURE SP_InsertPayment
@PaymentId varchar(20),
@CustomerId varchar(20),
@Payment float,
@PaymentDate datetime
AS
Begin
INSERT Into Payment
(PaymentId, CustomerId, Payment, PaymentDate)
VALUES (@PaymentId, @CustomerId, @Payment, @PaymentDate)
End
GO

CREATE PROCEDURE SP_InsertProviders
@IdProvider Varchar(20),
@CompanyName Varchar(100),
@Address Varchar(150),
@Phone Varchar(20)
AS
Begin
INSERT Into Supplier
(SupplierId, CompanyName, Address, Phone)
VALUES (@IdProvider, @CompanyName, @Address, @Phone)
End
GO

--Delete
CREATE PROCEDURE SP_DeleteProviders
@IdProvider Varchar(20)
AS
Begin
Delete from Supplier where @IdProvider = SupplierId
End
GO

CREATE PROCEDURE SP_DeleteCustomer
@CustomerId Varchar(20)
AS
Begin
Delete from Customer where @CustomerId = CustomerId
End
GO

CREATE PROCEDURE SP_DeleteInvoice
@InvoiceId Varchar(20)
AS
Begin
Delete from Invoice where @InvoiceId = InvoiceId
End
GO

CREATE PROCEDURE SP_DeleteProduct
@ProductId Varchar(20)
AS
Begin
Delete from Product where @ProductId = ProductId
End
GO

CREATE PROCEDURE SP_DeleteSale
@SaleId Varchar(20)
AS
Begin
Delete from Sale where @SaleId = SaleId
End
GO

CREATE PROCEDURE SP_DeletePayment
@PaymentId Varchar(20)
AS
Begin
Delete from Payment where @PaymentId = PaymentId
End
GO

CREATE PROCEDURE SP_DeleteSaleDetail
@SaleId Varchar(20),
@ProductId varchar(20)
AS
Begin
Delete from SaleDetail where @SaleId = SaleId and @ProductId = ProductId
End
GO

CREATE PROCEDURE SP_DeleteInvoiceDetail
@InvoiceId Varchar(20),
@ProductId Varchar(20)
AS
Begin
Delete from InvoiceDetail where @InvoiceId = InvoiceId and @ProductId = ProductId
End
GO

--Modify

CREATE PROCEDURE SP_ModifyProduct
@ProductId varchar(20),
@CategoryId varchar(20),
@ProductName varchar(20),
@UnitMeasure varchar(20),
@Stock float,
@UnitPrice float,
@InventoryType varchar(20)
AS
Begin
Update Product
Set CategoryId = @CategoryId,
Product = @ProductName,
UnitMeasure = @UnitMeasure,
UnitPrice = @UnitPrice,
Stock = @Stock,
InventoryType = @InventoryType
Where ProductId = @ProductId
End
GO

CREATE PROCEDURE SP_ModifyCustomer
@CustomerId varchar(20),
@FirstName Varchar(50),
@LastName varchar(50),
@Phone varchar(20),
@Address varchar(250),
@TotalCredit float,
@CreditLimit float
--@photo varchar(250) NULL
AS
Begin
Update Customer
Set
FirstName = @FirstName,
LastName = @LastName,
Phone = @Phone,
Address = @Address,
TotalCredit = @TotalCredit,
CreditLimit = @CreditLimit
Where CustomerId = @CustomerId
End
Go

CREATE PROCEDURE SP_ModifyInvoice
@InvoiceId varchar (20),
@CustomerId varchar(20),
@SaleType Varchar(20),
@InvoiceDate datetime,
@TotalInvoice float,
@Time varchar(10),
@Active bit
AS
Begin
Update Invoice
Set
CustomerId = @CustomerId,
SaleType = @SaleType,
InvoiceDate = @InvoiceDate,
TotalInvoice = @TotalInvoice,
Time = @Time,
Active = @Active
Where InvoiceId = @InvoiceId
End
Go

CREATE PROCEDURE SP_ModifySale
@SaleId Varchar(20),
@SupplierId Varchar(20),
@SaleDate datetime,
@TotalSale Float,
@Discount Float,
@Tax Float,
@GrandTotal Float
AS
Begin
Update Sale
Set
SupplierId = @SupplierId,
SaleDate = @SaleDate,
TotalSale = @TotalSale,
Discount = @Discount,
Tax = @Tax,
GrandTotal = @GrandTotal
Where SaleId = @SaleId
End
GO

CREATE PROCEDURE SP_ModifySaleDetail
@SaleId Varchar(20),
@ProductId Varchar(20),
@Stock Float,
@UnitCost Float,
@SubTotal Float
AS
Begin
Update SaleDetail
Set
Stock = @Stock,
UnitCost = @UnitCost,
SubTotal = @SubTotal
Where SaleId = @SaleId and ProductId = @ProductId
End
GO

CREATE PROCEDURE SP_ModifyInvoiceDetail
@InvoiceId Varchar(20),
@ProductId Varchar(20),
@Stock Float,
@SubTotal Float
AS
Begin
update InvoiceDetail
Set
Stock = @Stock,
SubTotal = @SubTotal
Where InvoiceId = @InvoiceId and ProductId = @ProductId
End
GO

CREATE PROCEDURE SP_ModifyPayment
@PaymentId varchar(20),
@CustomerId varchar(20),
@Payment Float,
@PaymentDate datetime
AS
Begin
Update Payment
Set
CustomerId = @CustomerId,
Payment = @Payment,
PaymentDate = @PaymentDate
Where PaymentId = @PaymentId
End
GO

CREATE PROCEDURE SP_ModifySuppliers
@SupplierId Varchar(20),
@CompanyName Varchar(100),
@Address Varchar(150),
@Phone Varchar(20)
AS
Begin
Update Supplier
Set
CompanyName = @CompanyName,
Address = @Address,
Phone = @Phone
Where SupplierId = @SupplierId
End
GO

EXEC SP_InsertCustomer @FirstName = N'Francisco Donald', @LastName = N'America Alcala', @Phone = N'88614476', @Address = N'Praderas del Doral, Alameda #7, casa #173', @TotalCredit = 2500, @CustomerId = '001-25051962-0007X', @CreditLimit = 184999
EXEC SP_InsertCustomer @FirstName = N'Juan', @LastName = N'Garcia', @Phone = N'5551234', @Address = N'Calle 123', @TotalCredit = 1000, @CustomerId = '001-01231980-0001A', @CreditLimit = 50000
EXEC SP_InsertCustomer @FirstName = N'Ana', @LastName = N'Martinez', @Phone = N'5555678', @Address = N'Calle 456', @TotalCredit = 5000, @CustomerId = '001-04021982-0002B', @CreditLimit = 100000
EXEC SP_InsertCustomer @FirstName = N'Carlos', @LastName = N'Perez', @Phone = N'5559012', @Address = N'Calle 789', @TotalCredit = 2000, @CustomerId = '001-07151977-0003C', @CreditLimit = 75000
EXEC SP_InsertCustomer @FirstName = N'Laura', @LastName = N'Sanchez', @Phone = N'5553456', @Address = N'Calle 246', @TotalCredit = 3000, @CustomerId = '001-02281985-0004D', @CreditLimit = 90000
EXEC SP_InsertCustomer @FirstName = N'Maria', @LastName = N'Lopez', @Phone = N'5557890', @Address = N'Calle 369', @TotalCredit = 4000, @CustomerId = '001-05011979-0005E', @CreditLimit = 80000
EXEC SP_InsertCustomer @FirstName = N'Jose', @LastName = N'Hernandez', @Phone = N'5554321', @Address = N'Calle 135', @TotalCredit = 1500, @CustomerId = '001-09101990-0006F', @CreditLimit = 60000
EXEC SP_InsertCustomer @FirstName = N'Paola', @LastName = N'Castillo', @Phone = N'5558765', @Address = N'Calle 579', @TotalCredit = 6000, @CustomerId = '001-03251981-0007G', @CreditLimit = 120000
EXEC SP_InsertCustomer @FirstName = N'Ricardo', @LastName = N'Gonzalez', @Phone = N'5552109', @Address = N'Calle 246', @TotalCredit = 8000, @CustomerId = '001-08221978-0008H', @CreditLimit = 160000
EXEC SP_InsertCustomer @FirstName = N'Fernanda', @LastName = N'Mendez', @Phone = N'5556543', @Address = N'Calle 802', @TotalCredit = 2500, @CustomerId = '001-06211983-0009I', @CreditLimit = 100000
EXEC SP_InsertCustomer @FirstName = N'Daniel', @LastName = N'Alvarez', @Phone = N'5550987', @Address = N'Calle 135', @TotalCredit = 3500, @CustomerId = '001-12101984-0010J', @CreditLimit = 110000
EXEC SP_InsertCustomer @FirstName = N'Sofia', @LastName = N'Rojas', @Phone = N'5555432', @Address = N'Calle 468', @TotalCredit = 4500, @CustomerId = '001-10071980-0011K', @CreditLimit = 90000
EXEC SP_InsertCustomer @FirstName = N'Jorge', @LastName = N'Vargas', @Phone = N'5559876', @Address = N'Calle 579', @TotalCredit = 2000, @CustomerId = '001-01141976-0012L', @CreditLimit = 60000
EXEC SP_InsertCustomer @FirstName = N'Isabella', @LastName = N'Ponce', @Phone = N'5553210', @Address = N'Calle 802', @TotalCredit = 6500, @CustomerId = '001-03021987-0013M', @CreditLimit = 130000
EXEC SP_InsertCustomer @FirstName = N'Pedro', @LastName = N'Ramirez', @Phone = N'5557654', @Address = N'Calle 135', @TotalCredit = 3000, @CustomerId = '001-08231989-0014N', @CreditLimit = 120000
EXEC SP_InsertCustomer @FirstName = N'Valentina', @LastName = N'Castro', @Phone = N'5552098', @Address = N'Calle 468', @TotalCredit = 5000, @CustomerId = '001-02171991-0015O', @CreditLimit = 100000
EXEC SP_InsertCustomer @FirstName = N'Emilio', @LastName = N'Gutierrez', @Phone = N'5556543', @Address = N'Calle 802', @TotalCredit = 1500, @CustomerId = '001-05221977-0016P', @CreditLimit = 50000
EXEC SP_InsertCustomer @FirstName = N'Giselle', @LastName = N'Ruiz', @Phone = N'5550987', @Address = N'Calle 135', @TotalCredit = 4000, @CustomerId = '001-04241985-0017Q', @CreditLimit = 80000
EXEC SP_InsertCustomer @FirstName = N'Mauricio', @LastName = N'Cortes', @Phone = N'5555432', @Address = N'Calle 468', @TotalCredit = 2500, @CustomerId = '001-06051978-0018R', @CreditLimit = 75000
EXEC SP_InsertCustomer @FirstName = N'Gonzalo', @LastName = N'Paredes', @Phone = N'5557654', @Address = N'Calle 579', @TotalCredit = 3500, @CustomerId = '001-01291988-0019S', @CreditLimit = 105000
EXEC SP_InsertCustomer @FirstName = N'Marcela', @LastName = N'Cruz', @Phone = N'5552098', @Address = N'Calle 802', @TotalCredit = 4500, @CustomerId = '001-05161979-0020T', @CreditLimit = 90000

-- Registros de Suppliers
EXEC SP_InsertSupplier 'S0001', 'Acme Inc.', '123 Main St.', '555-1234';
EXEC SP_InsertSupplier 'S0002', 'Widgets Inc.', '456 Oak Ave.', '555-5678';
EXEC SP_InsertSupplier 'S0003', 'Globex Corporation', '789 Elm St.', '555-9012';
EXEC SP_InsertSupplier 'S0004', 'Initech Industries', '321 Maple Blvd.', '555-3456';
EXEC SP_InsertSupplier 'S0005', 'Stark Industries', '1 Stark Tower', '555-7890';
EXEC SP_InsertSupplier 'S0006', 'Wayne Enterprises', '1007 Mountain Drive', '555-2468';
EXEC SP_InsertSupplier 'S0007', 'LexCorp Industries', '123 Luthor Rd.', '555-1357';
EXEC SP_InsertSupplier 'S0008', 'Oscorp Industries', '555 Fifth Ave.', '555-8642';
EXEC SP_InsertSupplier 'S0009', 'Umbrella Corporation', '123 Raccoon City', '555-7219';
EXEC SP_InsertSupplier 'S0010', 'Weyland-Yutani Corp.', '123 LV-426', '555-0987';
EXEC SP_InsertSupplier 'S0011', 'S.H.I.E.L.D.', '890 Fifth Ave.', '555-0123';
EXEC SP_InsertSupplier 'S0012', 'A.I.M. (Advanced Idea Mechanics)', '123 AIM Island', '555-4567';
EXEC SP_InsertSupplier 'S0013', 'Hydra', '123 Hydra Island', '555-2468';
EXEC SP_InsertSupplier 'S0014', 'The Hand', '123 Shadowlands', '555-5790';
EXEC SP_InsertSupplier 'S0015', 'H.A.M.M.E.R.', '123 Hammer Industries', '555-7263';
EXEC SP_InsertSupplier 'S0016', 'Roxxon Corporation', '123 Roxxon Building', '555-4321';
EXEC SP_InsertSupplier 'S0017', 'Stane International', '123 Stane Tower', '555-5678';
EXEC SP_InsertSupplier 'S0018', 'Pym Technologies', '123 Pym Building', '555-9012';
EXEC SP_InsertSupplier 'S0019', 'Daily Bugle', '123 Daily Bugle Building', '555-3456';
EXEC SP_InsertSupplier 'S0020', 'Stark-Fujikawa', '123 SF Building', '555-7890';

-- Registros de Productos
EXEC SP_InsertProduct 'P0001', 'C0001', 'Product A', 'Units', 10.99, 100, 'Type 1';
EXEC SP_InsertProduct 'P0002', 'C0001', 'Product B', 'Units', 19.99, 50, 'Type 2';
EXEC SP_InsertProduct 'P0003', 'C0001', 'Product C', 'Units', 5.99, 200, 'Type 3';
EXEC SP_InsertProduct 'P0004', 'C0001', 'Product D', 'Units', 8.99, 150, 'Type 2';
EXEC SP_InsertProduct 'P0005', 'C0001', 'Product E', 'Units', 12.99, 75, 'Type 1';
EXEC SP_InsertProduct 'P0006', 'C0001', 'Product F', 'Units', 16.99, 100, 'Type 2';
EXEC SP_InsertProduct 'P0007', 'C0001', 'Product G', 'Units', 7.99, 250, 'Type 3';
EXEC SP_InsertProduct 'P0008', 'C0001', 'Product H', 'Units', 21.99, 50, 'Type 1';
EXEC SP_InsertProduct 'P0009', 'C0001', 'Product I', 'Units', 13.99, 200, 'Type 2';
EXEC SP_InsertProduct 'P0010', 'C0001', 'Product J', 'Units', 11.99, 150, 'Type 3';
EXEC SP_InsertProduct 'P0011', 'C0002', 'Product K', 'Kilograms', 7.99, 100, 'Type 1';
EXEC SP_InsertProduct 'P0012', 'C0002', 'Product L', 'Kilograms', 15.99, 50, 'Type 2';
EXEC SP_InsertProduct 'P0013', 'C0002', 'Product M', 'Kilograms', 2.99, 200, 'Type 3';
EXEC SP_InsertProduct 'P0014', 'C0002', 'Product N', 'Kilograms', 5.99, 150, 'Type 2';
EXEC SP_InsertProduct 'P0015', 'C0002', 'Product O', 'Kilograms', 9.99, 75, 'Type 1';
EXEC SP_InsertProduct 'P0016', 'C0002', 'Product P', 'Kilograms', 13.99, 100, 'Type 2';
EXEC SP_InsertProduct 'P0017', 'C0002', 'Product Q', 'Kilograms', 3.99, 250, 'Type 3';
EXEC SP_InsertProduct 'P0018', 'C0002', 'Product R', 'Kilograms', 19.99, 50, 'Type 1';
EXEC SP_InsertProduct 'P0019', 'C0002', 'Product S', 'Kilograms', 10.99, 200, 'Type 2';
EXEC SP_InsertProduct 'P0020', 'C0002', 'Product T', 'Kilograms', 8.99, 150, 'Type 3';



-- Primero, insertamos 10 registros de venta en la tabla Sale
DECLARE @saleCounter INT = 1
WHILE (@saleCounter <= 10)
BEGIN
  DECLARE @saleId VARCHAR(20) = 'SALE' + CAST(@saleCounter AS VARCHAR(2))
  DECLARE @supplierId VARCHAR(20) = 'S000' + CAST((@saleCounter % 5) + 1 AS VARCHAR(2))
  DECLARE @saleDate DATETIME = DATEADD(DAY, @saleCounter, '2022-01-01')
  DECLARE @totalSale FLOAT = 1000.0 + @saleCounter * 100.0
  DECLARE @discount FLOAT = 0.0
  DECLARE @tax FLOAT = @totalSale * 0.15
  DECLARE @grandTotal FLOAT = @totalSale + @tax
  
  EXEC SP_InsertSale 
    @SaleId = @saleId, 
    @SupplierId = @supplierId, 
    @SaleDate = @saleDate, 
    @TotalSale = @totalSale, 
    @Discount = @discount, 
    @Tax = @tax, 
    @GrandTotal = @grandTotal
  
  -- Luego, para cada venta, insertamos 3 detalles de venta en la tabla SaleDetail
  DECLARE @detailCounter INT = 1
  WHILE (@detailCounter <= 3)
  BEGIN
    DECLARE @productId VARCHAR(20) = 'P000' + CAST((@saleCounter % 9) + 1 AS VARCHAR(2))
    DECLARE @stock FLOAT = 10.0 + @detailCounter
    DECLARE @unitCost FLOAT = 80.0 + @detailCounter * 10.0
    DECLARE @subTotal FLOAT = @stock * @unitCost
    
    EXEC SP_InsertSaleDetail 
      @SaleId = @saleId, 
      @ProductId = @productId, 
      @Stock = @stock, 
      @UnitCost = @unitCost, 
      @SubTotal = @subTotal
      
    SET @detailCounter = @detailCounter + 1
  END
  
  SET @saleCounter = @saleCounter + 1
END

-- Declare variables
DECLARE @customerId VARCHAR(20)
--DECLARE @productId VARCHAR(20)
DECLARE @invoiceId VARCHAR(20)
DECLARE @saleType VARCHAR(20)
DECLARE @invoiceDate DATETIME
DECLARE @totalInvoice FLOAT
DECLARE @time VARCHAR(10)
DECLARE @active BIT
--DECLARE @stock FLOAT
--DECLARE @subTotal FLOAT

-- Loop to insert 10 records
DECLARE @i INT = 1
WHILE @i <= 10
BEGIN
    -- Set values for variables
    SET @customerId = '001-25051962-0007X'
    SET @productId = 'P0001'
    SET @invoiceId = 'INV-000' + CAST(@i AS VARCHAR(2))
    SET @saleType = 'Retail'
    SET @invoiceDate = GETDATE()
    SET @totalInvoice = 1000.00 + @i * 100.00
    SET @time = '10:00 AM'
    SET @active = 1
    SET @stock = 10.00 + @i
    SET @subTotal = @totalInvoice / (@i + 1)

    -- Insert into Invoice table using SP_InsertInvoice
    EXEC SP_InsertInvoice
        @InvoiceId = @invoiceId,
        @CustomerId = @customerId,
        @SaleType = @saleType,
        @InvoiceDate = @invoiceDate,
        @TotalInvoice = @totalInvoice,
        @Time = @time,
        @active = @active

    -- Insert into InvoiceDetail table using SP_InsertInvoiceDetail
    EXEC SP_InsertInvoiceDetail
        @InvoiceId = @invoiceId,
        @ProductId = @productId,
        @Stock = @stock,
        @SubTotal = @subTotal

    -- Increment loop counter
    SET @i = @i + 1
END

EXEC SP_InsertPayment 
   @PaymentId = 'P0001',
   @CustomerId = '001-01141976-0012L',
   @Payment = 500.00,
   @PaymentDate = '2023-04-25 12:30:00'

EXEC SP_InsertPayment 
   @PaymentId = 'P0002',
   @CustomerId = '001-02171991-0015O',
   @Payment = 500.00,
   @PaymentDate = '2023-04-25 12:30:00'

EXEC SP_InsertPayment 
    @PaymentId = 'P0003',
    @CustomerId = '001-01231980-0001A',
    @Payment = 500.00,
    @PaymentDate = '2023-04-25 12:30:00'


GO
-- Views 
CREATE VIEW Vw_VisualizeCustomer AS
SELECT CustomerId, FirstName, LastName, Phone, Address FROM Customer

GO
CREATE VIEW Vw_ObtainAvailableProducts
AS
SELECT ProductId, CategoryId, Product, UnitMeasure, UnitPrice, Stock, InventoryType
FROM Product
WHERE Stock > 0

GO
CREATE VIEW Vw_ObtainProducts
AS
SELECT ProductId, CategoryId, Product, UnitMeasure, UnitPrice, Stock, InventoryType
FROM Product

