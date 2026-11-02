DECLARE @FundingStreamPeriodDeliverable TABLE ([FundingStreamPeriodCode] [nvarchar](100) NOT NULL, [DeliverableCode] [int] NOT NULL, 
[ParentDeliverableCode] [int], [DeliverableName] [nvarchar](100) NOT NULL, [AllowProfile] [bit], [AllowActuals] [bit], [AllowPayment] [bit]);

INSERT INTO @FundingStreamPeriodDeliverable ([FundingStreamPeriodCode], [DeliverableCode], [ParentDeliverableCode], [DeliverableName], [AllowProfile], [AllowActuals], [AllowPayment]) VALUES ('24+ ALLBC','24+ Advanced Learning Loans Bursary (College)','LBCO','SFA')
INSERT INTO @PaymentGenerationFundingStream ([Code], [Name], [FinanceShortCode], [AgencyCode]) VALUES ('ASC','Adult Skills (College)','ASCO','SFA')
INSERT INTO @PaymentGenerationFundingStream ([Code], [Name], [FinanceShortCode], [AgencyCode]) VALUES ('CL','Community Learning','CL','SFA')
INSERT INTO @PaymentGenerationFundingStream ([Code], [Name], [FinanceShortCode], [AgencyCode]) VALUES ('DLS','Discretionary Learner Support','DLS','SFA')
INSERT INTO @PaymentGenerationFundingStream ([Code], [Name], [FinanceShortCode], [AgencyCode]) VALUES ('OLASS','Adult OLASS','LASS','SFA')
INSERT INTO @PaymentGenerationFundingStream ([Code], [Name], [FinanceShortCode], [AgencyCode]) VALUES ('16-18 Apps','16-18 Apprenticeships','AP16','SFA')
INSERT INTO @PaymentGenerationFundingStream ([Code], [Name], [FinanceShortCode], [AgencyCode]) VALUES ('24+ ALLB','24+ Advanced Learning Loans Bursary','LBT','SFA')
INSERT INTO @PaymentGenerationFundingStream ([Code], [Name], [FinanceShortCode], [AgencyCode]) VALUES ('ASTO','Adult Skills (Training Organisations)','AST','SFA')
INSERT INTO @PaymentGenerationFundingStream ([Code], [Name], [FinanceShortCode], [AgencyCode]) VALUES ('EOP','Employer Ownership Pilot','EMP','SFA')
INSERT INTO @PaymentGenerationFundingStream ([Code], [Name], [FinanceShortCode], [AgencyCode]) VALUES ('AGE','Apprenticeship Grant for Employers','AGE','SFA')
INSERT INTO @PaymentGenerationFundingStream ([Code], [Name], [FinanceShortCode], [AgencyCode]) VALUES ('24+ ALLF','24+ Advance Learning Loans Facility','ALLF','SFA')

MERGE INTO [PaymentGeneration].[FundingStream] t
USING @PaymentGenerationFundingStream s
ON s.Code = t.Code
WHEN MATCHED THEN
    UPDATE SET t.Name = s.Name,
    t.FinanceShortCode = s.FinanceShortCode,
    t.AgencyCode = s.AgencyCode
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Code], [Name], [FinanceShortCode], [AgencyCode]) 
    VALUES (s.Code, s.Name, s.FinanceShortCode, s.AgencyCode);