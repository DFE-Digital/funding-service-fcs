namespace SFA.FCT.Contracts.AcceptanceTests.Pages
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Globalization;
    using System.IO;
    using System.Linq;
    using System.Threading.Tasks;
    using System.Xml;
    using AutoMapper;
    using CrossDomain.Integration.Common.Storage;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DocumentsDomain.Common.Models;
    using Extensions;
    using NUnit.Framework;
    using Utilities;
    using AzureStorageWrapper = DocumentsDomain.Integration.AzureStorageWrapper;
    using FctFile = DocumentsDomain.Common.Models.FctFile;
    using XmlSerializer = System.Xml.Serialization.XmlSerializer;

    public class ContractDocumentGenerationPageObject
    {
        private readonly IOffice365Adapter _officeAdapter = new Office365StorageWrapper();
        private readonly AzureStorageWrapper _azureStorageWrapper = new AzureStorageWrapper();
        private const string ContractUri = "urn:sfa:schemas:contract";
        private PdfAdapter _pdfAdapter;

        public ContractDocumentGenerationPageObject()
        {
            MergeData = new DocumentGenerationRequestMergeData();
        }

        public DocumentGenerationRequestMergeData MergeData { get; }

        public string TargetFileName { get; set; }

        public string DocumentLocation { get; set; }

        private static string AzureDocumentContainerName => ConfigurationManager.AppSettings["DocumentGeneration.TargetContainer"];

        private static bool UseAzureStorageForDocuments => ConfigurationManager.AppSettings["UseAzureStorageForDocuments"] == "true";

        public contract MasterContract { get; set; }

        public string FundingTypePeriod { get; set; }

        public string FundingTypeCode { get; set; }

        private XmlDocument CreateDocumentFromDocumentGenerationRequest()
        {
            if (FundingTypePeriod == null)
            {
                Assert.Fail("FundingTypePeriod has not been set");
            }
            if (FundingTypeCode == null)
            {
                Assert.Fail("FundingTypeCode has not been set");
            }
            XmlDocument doc = new XmlDocument();
            doc.LoadXml("<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                        "<ctr:contract schemaVersion=\"8.00\" schemaLocation=\"contract D:\\TFS\\FCT\\Main\\Corporate\\Schemas\\contract_corporate_schema.xsd\" xmlns:ctr=\"urn:sfa:schemas:contract\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" />");
            Dictionary<string, MergeFieldType> contractDictionary = MergeData.MergeFields.ToDictionary(mf => mf.Name);
            XmlElement contractsElement = doc.DocumentElement.AddElement("ctr:contracts", ContractUri);
            XmlElement contractElement = contractsElement.AddElement("ctr:contract", ContractUri);
            AddFundingPeriod(contractElement, string.Empty);
            XmlElement contractAllocations = contractElement.AddElement("ctr:contractAllocations", ContractUri);
            contractElement.AddElement("ctr:contractNumber", ContractUri, contractDictionary["CONTRACTNUMBER"].Value);
            contractElement.AddElement("ctr:contractVersionNumber", ContractUri, contractDictionary["contractVersionNumber"].Value);
            AddContractor(contractElement, contractDictionary["ukprn"].Value, contractDictionary["legalName"].Value);
            contractElement.AddElement("ctr:hierarchyType", ContractUri, "CONTRACT");
            Dictionary<string, RepeatingSectionType> repeatingSections = new Dictionary<string, RepeatingSectionType>();
            foreach (RepeatingSectionType repeatingSection in MergeData.RepeatingSections)
            {
                repeatingSections.Add(repeatingSection.Name, repeatingSection);
            }
            if (repeatingSections.ContainsKey("contractAllocation"))
            {
                foreach (RowType row in repeatingSections["contractAllocation"].Rows)
                {
                    XmlElement allocationRowElement = contractAllocations.AddElement(
                        "ctr:contractAllocation",
                        ContractUri);
                    Dictionary<string, MergeFieldType> allocationRowDictionary =
                        row.MergeFields.ToDictionary(mf => mf.Name);
                    string fundingStreamPeriodCode = string.Empty;
                    if (allocationRowDictionary.ContainsKey("fundingStreamPeriodCode"))
                    {
                        fundingStreamPeriodCode = allocationRowDictionary["fundingStreamPeriodCode"].Value;
                    }
                    AddFundingPeriod(allocationRowElement, fundingStreamPeriodCode);
                    allocationRowElement.AddElement("ctr:fundingStream", ContractUri)
                        .AddElement(
                            "ctr:fundingStreamCode",
                            ContractUri,
                            allocationRowDictionary["fundingStreamCode"].Value)
                        .ParentAsElement()
                        .AddElement("ctr:fundingStreamName", ContractUri)
                        .ParentAsElement()
                        .AddElement("ctr:fundingTypeCode", ContractUri, "1")
                        .ParentAsElement()
                        .AddElement(
                            "ctr:fundingStreamShortCode",
                            ContractUri,
                            allocationRowDictionary["fundingStreamCode"].Value.Substring(0, Math.Min(allocationRowDictionary["fundingStreamCode"].Value.Length, 6)));
                    XmlElement contractDeliverablesElement = allocationRowElement.AddElement("ctr:contractDeliverables", ContractUri);
                    if (repeatingSections.ContainsKey("contractDeliverable"))
                    {
                        foreach (RowType deliverableRow in repeatingSections["contractDeliverable"].Rows)
                        {
                            Dictionary<string, MergeFieldType> deliverableRowDictionary =
                                deliverableRow.MergeFields.ToDictionary(mf => mf.Name);
                            RowType deliverableVolumeRows = null;
                            if (repeatingSections.ContainsKey("contractDeliverableVolume"))
                            {
                                deliverableVolumeRows =
                                    (from volumneRow in repeatingSections["contractDeliverableVolume"].Rows
                                     where
                                         deliverableRowDictionary["deliverableCode"].Value ==
                                         volumneRow.MergeFields.Find(m => m.Name == "deliverableCode").Value &&
                                         deliverableRowDictionary["contractAllocationNumber"].Value ==
                                         volumneRow.MergeFields.Find(m => m.Name == "contractAllocationNumber").Value
                                     select volumneRow).FirstOrDefault();
                            }
                            // if there is only one Allocation OR the contractAllocationNumbers match
                            if (repeatingSections["contractAllocation"].Rows.Count == 1 ||
                                (allocationRowDictionary.ContainsKey("contractAllocationNumber") &&
                                 deliverableRowDictionary.ContainsKey("contractAllocationNumber") &&
                                 allocationRowDictionary["contractAllocationNumber"].Value ==
                                 deliverableRowDictionary["contractAllocationNumber"].Value))
                            {
                                XmlElement contractDeliverableElement = contractDeliverablesElement.AddElement("ctr:contractDeliverable", ContractUri);
                                contractDeliverableElement
                                    .AddElement("ctr:deliverable", ContractUri)
                                    .AddElement("ctr:fundingStreamCode", ContractUri, allocationRowDictionary["fundingStreamCode"].Value)
                                    .ParentAsElement()
                                    .AddElement(
                                        "ctr:deliverableCode",
                                        ContractUri,
                                        deliverableRowDictionary["deliverableCode"].Value.Length > 0
                                            ? deliverableRowDictionary["deliverableCode"].Value
                                            : "1");
                                XmlElement contractDeliverablePeriodsElement = contractDeliverableElement.AddElement("ctr:contractDeliverablePeriods", ContractUri);
                                string[] months = new string[] { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };
                                foreach (string month in deliverableRowDictionary.Where(x => months.Contains(x.Key.Substring(0, 3))).Select(x => x.Key))
                                {
                                    if (deliverableRowDictionary.ContainsKey(month) && deliverableRowDictionary[month].Value.Length > 0)
                                    {
                                        XmlElement contractDeliverablePeriodElement =
                                            contractDeliverablePeriodsElement.AddElement("ctr:contractDeliverablePeriod", ContractUri);
                                        contractDeliverablePeriodElement.AddElement("ctr:year", ContractUri, month.Substring(3));
                                        string monthNumberAsString = DateTime.ParseExact(month.Substring(0, 3), "MMM", null).Month.ToString();
                                        contractDeliverablePeriodElement.AddElement(
                                            "ctr:period",
                                            ContractUri,
                                            monthNumberAsString);
                                        contractDeliverablePeriodElement
                                            .AddElement("ctr:periodType", ContractUri)
                                            .AddElement("ctr:periodTypeCode", ContractUri, "CM")
                                            .ParentAsElement()
                                            .AddElement("ctr:periodTypeName", ContractUri, "CALENDAR MONTH");
                                        if (deliverableVolumeRows != null)
                                        {
                                            contractDeliverablePeriodElement.AddElement(
                                                "ctr:plannedVolume",
                                                ContractUri,
                                                deliverableVolumeRows.MergeFields.Find(m => m.Name == month).Value);
                                        }
                                        contractDeliverablePeriodElement.AddElement(
                                            "ctr:plannedValue",
                                            ContractUri,
                                            deliverableRowDictionary[month].Value);
                                    }
                                }
                                contractDeliverableElement.AddElement("ctr:deliverableDescription", ContractUri, deliverableRowDictionary["deliverableDescription"].Value);
                                int unitCost;
                                if (deliverableRowDictionary.ContainsKey("UnitCost") && deliverableRowDictionary["UnitCost"].Value != null && int.TryParse(deliverableRowDictionary["UnitCost"].Value, out unitCost))
                                {
                                    contractDeliverableElement.AddElement("ctr:unitCost", ContractUri, unitCost.ToString());
                                }
                            }
                        }
                    }
                    allocationRowElement.AddElement("ctr:contractAllocationNumber", ContractUri, allocationRowDictionary["contractAllocationNumber"].Value);
                    allocationRowElement.AddElement("ctr:description", ContractUri, allocationRowDictionary["description"].Value);
                    allocationRowElement.AddElement("ctr:hierarchyType", ContractUri, "CONTRACT ALLOCATION");
                    allocationRowElement.AddElement("ctr:fundingStreamPeriodCode", ContractUri, allocationRowDictionary["fundingStreamPeriodCode"].Value);
                    if (allocationRowDictionary.ContainsKey("startDate") && allocationRowDictionary.ContainsKey("endDate"))
                    {
                        DateTime startDate = DateTime.MinValue;
                        if (!DateTime.TryParseExact(allocationRowDictionary["startDate"].Value, "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.AssumeUniversal, out startDate))
                        {
                            if (!DateTime.TryParseExact(allocationRowDictionary["startDate"].Value, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.AssumeUniversal, out startDate))
                            {
                                Assert.Fail("Date format of allocation start date not recognized");
                            }
                        }
                        DateTime endDate = DateTime.MinValue;
                        if (!DateTime.TryParseExact(allocationRowDictionary["endDate"].Value, "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.AssumeUniversal, out endDate))
                        {
                            if (!DateTime.TryParseExact(allocationRowDictionary["endDate"].Value, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.AssumeUniversal, out endDate))
                            {
                                Assert.Fail("Date format of allocation end date not recognized");
                            }
                        }
                        allocationRowElement.AddElement("ctr:startDate", ContractUri, startDate.ToString("yyyy-MM-dd"));
                        allocationRowElement.AddElement("ctr:endDate", ContractUri, endDate.ToString("yyyy-MM-dd"));
                    }
                    else if (FundingTypePeriod != null)
                    {
                        allocationRowElement.AddElement("ctr:startDate", ContractUri, "20" + FundingTypePeriod.Substring(0, 2) + "-08-01");
                        allocationRowElement.AddElement("ctr:endDate", ContractUri, "20" + FundingTypePeriod.Substring(2, 2) + "-07-31");
                    }
                    if (allocationRowDictionary.ContainsKey("maximumContractValue"))
                    {
                        allocationRowElement.AddElement("ctr:maximumContractValue", ContractUri, allocationRowDictionary["maximumContractValue"].Value);
                    }
                }
            }
            if (contractDictionary.ContainsKey("startDate") && contractDictionary.ContainsKey("endDate"))
            {
                DateTime startDate = DateTime.MinValue;
                if (!DateTime.TryParseExact(contractDictionary["startDate"].Value, "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.AssumeUniversal, out startDate))
                {
                    if (!DateTime.TryParseExact(contractDictionary["startDate"].Value, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.AssumeUniversal, out startDate))
                    {
                        Assert.Fail("Date format of allocation start date not recognized");
                    }
                }
                DateTime endDate = DateTime.MinValue;
                if (!DateTime.TryParseExact(contractDictionary["endDate"].Value, "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.AssumeUniversal, out endDate))
                {
                    if (!DateTime.TryParseExact(contractDictionary["endDate"].Value, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.AssumeUniversal, out endDate))
                    {
                        Assert.Fail("Date format of allocation end date not recognized");
                    }
                }
                contractElement.AddElement("ctr:startDate", ContractUri, startDate.ToString("yyyy-MM-dd"));
                contractElement.AddElement("ctr:endDate", ContractUri, endDate.ToString("yyyy-MM-dd"));
            }
            else if (FundingTypePeriod != null)
            {
                if (FundingTypeCode == "AGE")
                {
                    contractElement.AddElement("ctr:startDate", ContractUri, "20" + FundingTypePeriod.Substring(0, 2) + "-04-01");
                    contractElement.AddElement("ctr:endDate", ContractUri, "20" + FundingTypePeriod.Substring(2, 2) + "-03-31");
                }
                else
                {
                    contractElement.AddElement("ctr:startDate", ContractUri, "20" + FundingTypePeriod.Substring(0, 2) + "-08-01");
                    contractElement.AddElement("ctr:endDate", ContractUri, "20" + FundingTypePeriod.Substring(2, 2) + "-07-31");
                }
            }
            AddStatus(contractElement, "DRAFT", "DRAFT");
            if (contractDictionary.ContainsKey("contractValue"))
            {
                contractElement.AddElement("ctr:contractValue", ContractUri, contractDictionary["contractValue"].Value);
            }
            AddFundingType(doc.DocumentElement);
            AddFundingPeriod(doc.DocumentElement, string.Empty);
            doc.DocumentElement.AddElement("ctr:contractNumber", ContractUri, contractDictionary["MASTERCONTRACTNUMBER"].Value);
            doc.DocumentElement.AddElement("ctr:contractVersionNumber", ContractUri, contractDictionary["contractVersionNumber"].Value);
            AddContractor(doc.DocumentElement, contractDictionary["ukprn"].Value, contractDictionary["legalName"].Value);
            doc.DocumentElement.AddElement("ctr:hierarchyType", ContractUri, "MASTER CONTRACT");
            AddStatus(doc.DocumentElement, "DRAFT", "DRAFT");
            return doc;
        }

        private void EnrichCorporateContractWithEsfSpecificValues(contract contract)
        {
            Dictionary<string, RepeatingSectionType> repeatingSections = MergeData.RepeatingSections.ToDictionary(rs => rs.Name);
            if (repeatingSections.ContainsKey("contractAllocation"))
            {
                foreach (RowType row in repeatingSections["contractAllocation"].Rows)
                {
                    Dictionary<string, MergeFieldType> allocationRowDictionary = row.MergeFields.ToDictionary(mf => mf.Name);
                    string allocationNumber = allocationRowDictionary["contractAllocationNumber"].Value;
                    contractAllocationsContractAllocation allocation = contract.contracts[0].contractAllocations.Single(a => a.contractAllocationNumber == allocationNumber);
                    if (allocationRowDictionary.ContainsKey("Agreement"))
                    {
                        allocation.AgreementNumber = allocationRowDictionary["Agreement"].Value;
                    }
                    if (allocationRowDictionary.ContainsKey("LEP"))
                    {
                        allocation.LEPName = allocationRowDictionary["LEP"].Value;
                    }
                    if (allocationRowDictionary.ContainsKey("ITT Reference"))
                    {
                        allocation.tenderSpecificationReference = allocationRowDictionary["ITT Reference"].Value;
                    }
                    if (allocationRowDictionary.ContainsKey("Lot Ref"))
                    {
                        allocation.lotReference = allocationRowDictionary["Lot Ref"].Value;
                    }
                    if (allocationRowDictionary.ContainsKey("Specification Title"))
                    {
                        allocation.SpecificationTitle = allocationRowDictionary["Specification Title"].Value;
                    }
                }
            }
        }

        public void VerifyLinesInOrderAndAssertIfNotFound(string multilineText)
        {
            Dictionary<string, MergeFieldType> contractDictionary = MergeData.MergeFields.ToDictionary(mf => mf.Name);
            string filename = string.Format("D:\\LoadTests\\SourceDocs\\{0}_{1}_v{2}.txt",
                contractDictionary["ukprn"].Value,
                contractDictionary["CONTRACTNUMBER"].Value,
                contractDictionary["contractVersionNumber"].Value);
            FileInfo expectedTextFile = new FileInfo(filename);
            ////using (FileStream fs = expectedTextFile.OpenWrite())
            ////using (StreamWriter sw = new StreamWriter(fs))
            ////    sw.Write(multilineText);
            GetPdfFile().VerifyLinesInOrderAndAssertIfNotFound(multilineText);
        }

        public void VerifyLinesInOrderAndAssertIfNotFoundWithoutMergeData(string multilineText)
        {
            GetPdfFile().VerifyLinesInOrderAndAssertIfNotFound(multilineText);
        }

        public void VerifyParameterizedLinesInOrderAndAssertIfNotFound(string multilineText)
        {
            GetPdfFile().VerifyLinesInOrderAndAssertIfNotFound(multilineText);
        }

        public void VerifyPageLinesInOrderAndAssertIfNotFound(string multilineText)
        {
            _pdfAdapter = null;
            GetPdfFile().VerifyLinesInOrderAndAssertIfNotFound(multilineText);
        }

        public void VerifyLinesAreNotPresentInOrderAndAssertIfFound(string multilineText)
        {
            GetPdfFile().VerifyLinesAreNotPresentInOrderAndAssertIfFound(multilineText);
        }

        public void VerifyTextNotPresentAndAssertIfFound(string multilineText)
        {
            GetPdfFile().VerifyTextNotPresentAndAssertIfFound(multilineText);
        }

        public decimal ExtractLineIfFound(string searchString)
        {
            _pdfAdapter = null;
            return GetPdfFile().ExtractLineIfFound(searchString);
        }

        public contract GetContractUsingInputData()
        {
            if (MasterContract == null)
            {
                XmlDocument doc = CreateDocumentFromDocumentGenerationRequest();
                using (MemoryStream ms = new MemoryStream())
                {
                    StreamWriter writer = new StreamWriter(ms);
                    writer.Write(doc.OuterXml);
                    writer.Flush();
                    ms.Position = 0;
                    XmlSerializer xs = new XmlSerializer(typeof(contract));
                    xs.UnknownAttribute += (sender, e) => {};
                    xs.UnknownElement += (sender, e) => {};
                    MasterContract = xs.Deserialize(ms) as contract;
                }
                if (MasterContract != null)
                {
                    // shockingly.. but unable to enhance CreateDocumentFromDocumentGenerationRequest method with ESF values for unknown reason
                    EnrichCorporateContractWithEsfSpecificValues(MasterContract);
                }
            }
            return MasterContract;
        }

        private static contract TransformContractTypeToContract(contractType contractType)
        {
            Mapper.CreateMap<contractType, contract>();
            return Mapper.Map<contractType, contract>(contractType);
        }

        public contract CreateDeletingContract(int ukprn, string contractNumber, int contractVersion)
        {
            contract delContract = new contract();
            delContract.contracts.Add(new contractType()
            {
                contractor = new contractor()
                {
                    ukprn = ukprn
                },
                contractNumber = contractNumber,
                contractVersionNumber = contractVersion
            });
            return delContract;
        }

        public void CreateEmptyFile(string fileName, string listName)
        {
            if (UseAzureStorageForDocuments)
            {
                FctFile file = new FctFile(AzureDocumentContainerName, fileName);
                _azureStorageWrapper.PutBlockBlob(file, new byte[1]);
            }
            else
            {
                _officeAdapter.UploadFile(fileName, new byte[1], listName);
            }
        }

        public void DeleteFile(string fileName, string location)
        {
            if (UseAzureStorageForDocuments)
            {
                FctFile file = new FctFile(AzureDocumentContainerName, fileName);
                if (_azureStorageWrapper.DoesBlockBlobExist(file))
                {
                    _azureStorageWrapper.DeleteBlockBlob(file);
                }
            }
            else
            {
                //Debug.WriteLine($"Deleting file: {fileName} from {location}");
                _officeAdapter.DeleteFile(fileName, location);
            }
        }

        public void UploadFileToSharePoint(string libraryName, string fileName)
        {
            _officeAdapter.UploadFileWithOverwrite(fileName, ResourceManager.GetEmbeddedResourceAsBytes(fileName), libraryName);
        }

        public void UploadFileToSharePoint(string libraryName, string targetFileName, string resourceFileName)
        {
            _officeAdapter.UploadFileWithOverwrite(targetFileName, ResourceManager.GetEmbeddedResourceAsBytes(resourceFileName), libraryName);
        }

        public void UploadFileToSharePointBasedOnTemplate(string libraryName, string fileName, string templateFileName)
        {
            _officeAdapter.UploadFileWithOverwrite(fileName, ResourceManager.GetEmbeddedResourceAsBytes(templateFileName), libraryName);
        }

        public bool DoesFileExist(string listName, string fileName)
        {
            bool fileFound = false;
            for (int timeout = 0; timeout < 10; timeout++)
            {
                // Check to see if the PDF is going to appear in the azure cloud or on the Teamsite
                if (UseAzureStorageForDocuments)
                {
                    if (_azureStorageWrapper.DoesBlockBlobExist(new FctFile(AzureDocumentContainerName, fileName)))
                    {
                        fileFound = true;
                        break;
                    }
                }
                else
                {
                    if (_officeAdapter.DoesFileExist(listName, fileName))
                    {
                        fileFound = true;
                        break;
                    }
                }
                Task.Delay(500).Wait();
            }
            return fileFound;
        }

        public int GetSharePointFileVersionCount(string listName, string fileName)
        {
            var versionCount = _officeAdapter.GetFileVersionCount(fileName, listName);
            return versionCount;
        }

        public void RemovePdfFromCache()
        {
            _pdfAdapter = null;
        }

        private void AddFundingPeriod(XmlElement contractElement, string fundingStreamPeriodCode)
        {
            XmlElement periodElement = contractElement.AddElement("ctr:period", ContractUri);
            XmlElement periodTypeElement = periodElement.AddElement("ctr:periodType", ContractUri);
            if (FundingTypeCode == "ESF")
            {
                periodTypeElement.AddElement("ctr:periodTypeCode", ContractUri, "ESF")
                    .ParentAsElement()
                    .AddElement("ctr:periodTypeName", ContractUri, "EUROPEAN SOCIAL FUND");
            }
            else if (FundingTypeCode == "AGE")
            {
                periodTypeElement.AddElement("ctr:periodTypeCode", ContractUri, "FY")
                    .ParentAsElement()
                    .AddElement("ctr:periodTypeName", ContractUri, "FINANCIAL YEAR");
            }
            else if (FundingTypeCode == "NONLEVY")
            {
                periodTypeElement.AddElement("ctr:periodTypeCode", ContractUri, "NONLEVY")
                    .ParentAsElement()
                    .AddElement("ctr:periodTypeName", ContractUri, "NON-LEVY APPRENTICESHIPS");
            }
            else
            {
                periodTypeElement.AddElement("ctr:periodTypeCode", ContractUri, "AY")
                    .ParentAsElement()
                    .AddElement("ctr:periodTypeName", ContractUri, "ACADEMIC YEAR");
            }
            periodElement.AddElement("ctr:fundingStreamPeriods", ContractUri)
                .AddElement("ctr:fundingStreamPeriod", ContractUri)
                .AddElement("ctr:fundingStreamPeriodCode", ContractUri, fundingStreamPeriodCode);
            periodElement.AddElement("ctr:period", ContractUri, FundingTypePeriod);
            if (FundingTypeCode == "ESF" && FundingTypePeriod == "1420")
            {
                periodElement.AddElement("ctr:startDate", ContractUri, "2014-08-01");
                periodElement.AddElement("ctr:endDate", ContractUri, "2022-12-31");
            }
            else if (FundingTypeCode == "AGE")
            {
                periodElement.AddElement("ctr:startDate", ContractUri, "20" + FundingTypePeriod.Substring(0, 2) + "-04-01");
                periodElement.AddElement("ctr:endDate", ContractUri, "20" + FundingTypePeriod.Substring(2, 2) + "-03-31");
            }
            else if (FundingTypeCode != "ESF")
            {
                periodElement.AddElement("ctr:startDate", ContractUri, "20" + FundingTypePeriod.Substring(0, 2) + "-08-01");
                periodElement.AddElement("ctr:endDate", ContractUri, "20" + FundingTypePeriod.Substring(2, 2) + "-07-31");
            }
        }

        private static void AddStatus(XmlElement parent, string status, string parentStatus)
        {
            parent.AddElement("ctr:contractStatus", ContractUri)
                .AddElement("ctr:status", ContractUri, status)
                .ParentAsElement()
                .AddElement("ctr:parentStatus", ContractUri, parentStatus)
                .ParentAsElement();
        }

        private void AddFundingType(XmlElement parent)
        {
            parent.AddElement("ctr:fundingType", ContractUri)
                .AddElement("ctr:fundingTypeCode", ContractUri, FundingTypeCode)
                .ParentAsElement()
                .AddElement("ctr:fundingTypeName", ContractUri)
                .ParentAsElement();
        }

        private static void AddContractor(XmlElement parent, string ukprn, string legalName)
        {
            parent.AddElement("ctr:contractor", ContractUri)
                .AddElement("ctr:organisationIdentifier", ContractUri, "0")
                .ParentAsElement()
                .AddElement("ctr:ukprn", ContractUri, ukprn)
                .ParentAsElement()
                .AddElement("ctr:legalName", ContractUri, legalName)
                .ParentAsElement();
        }

        private PdfAdapter GetPdfFile()
        {
            if (_pdfAdapter == null)
            {
                if (UseAzureStorageForDocuments)
                {
                    _pdfAdapter =
                        new PdfAdapter(
                            new AzureStorageWrapper().GetBlockBlobContents(new FctFile(
                                AzureDocumentContainerName,
                                TargetFileName)));
                }
                else
                {
                    _pdfAdapter =
                        new PdfAdapter(
                            new Office365StorageWrapper().GetFileContents(DocumentLocation, string.Empty, TargetFileName));
                }
            }
            return _pdfAdapter;
        }
    }
}