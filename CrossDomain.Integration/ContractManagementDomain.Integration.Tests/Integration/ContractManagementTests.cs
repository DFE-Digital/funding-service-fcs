namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using Aspose.Cells;
    using CrossDomain.Integration.Common;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using UnitTests.Common;

    [TestClass]
    public class ContractManagementTests
    {
        const string FsfFileName = "Resources.SFS_Contracts_2013_10_12_11_20.xlsx";
        const string LiveDataFileName = "Resources.Extract_From_Live.xlsx";

        private readonly IList<FundingTypeInfo> _fundingTypeInfos = new List<FundingTypeInfo>
        {
            // new FundingTypeInfo("MAIN", new DateTime(2016, 5, 4, 9, 6, 38, DateTimeKind.Utc)),
            // new FundingTypeInfo("ESIF", new DateTime(2016, 4, 28, 13, 50, 10, DateTimeKind.Utc)),
            // new FundingTypeInfo("Loans", new DateTime(2016, 7, 15, 14, 03, 10, DateTimeKind.Utc)),
            //new FundingTypeInfo("AGE", new DateTime(2016, 8, 8, 8, 42, 08, DateTimeKind.Utc)),
            new FundingTypeInfo("EMP1", new DateTime(2016, 7, 15, 14, 00, 00, DateTimeKind.Utc)),
        };

        [TestMethod, TestCategory("TechnicalExploration")]
        public void ShouldHaveAllContractsInSfsSpreadsheet()
        {
            SetupLicence();

            Workbook workbook = GetWorkBook(FsfFileName);

            IReadOnlyCollection<ContractInfo> fsfContractInfos = GetContractInfosFromWorkbook(workbook, TransformRowToContractInfo, "Sheet1");

            CompareContractInfosToPaas(fsfContractInfos);

            Assert.IsNotNull(workbook);
        }

        private void CompareContractInfosToPaas(IReadOnlyCollection<ContractInfo> contractInfos)
        {
            foreach (var fundingTypeInfo in _fundingTypeInfos)
            {
                var distinctSfsContractInfos =
                    contractInfos.Where(c => c.ContractNumber.Contains(fundingTypeInfo.FundingType)).Distinct().ToList();
                Assert.IsTrue(distinctSfsContractInfos.Count > 0);

                IReadOnlyCollection<ContractInfo> atomFeedContractInfos = GetAtomFeedItemsForFundingTypeFromADate(fundingTypeInfo);
               
                var differences = atomFeedContractInfos.Where(a => !distinctSfsContractInfos.Contains(a)).ToList();

                var differencesInverse = distinctSfsContractInfos.Where(a => !atomFeedContractInfos.Contains(a)).ToList();

                Assert.IsTrue(!differences.Any());

                Assert.AreEqual(atomFeedContractInfos.Count, distinctSfsContractInfos.Count, "The number of contracts in SFS does not match for this funding type");
            }
        }

        private IReadOnlyCollection<ContractInfo> GetAtomFeedItemsForFundingTypeFromADate(
            FundingTypeInfo fundingTypeInfo)
        {
            Workbook workbook = GetWorkBook(LiveDataFileName);

            var contractInfos = GetContractInfosFromWorkbook(workbook, TransformLiveRowToContractInfo,
                "contract_Atom_Feed_Item_export");

            var filtered =
                contractInfos.Where(
                    c =>
                        c.ContractNumber.Contains(fundingTypeInfo.FundingType) &&
                        c.CreatedDate > fundingTypeInfo.FromDate).ToList();

            var groups = filtered.GroupBy(f => new {Number = f.ContractNumber, Version = f.Version});

            List<ContractInfo> contractInfosThatArePublished = new List<ContractInfo>();
            foreach (var group in groups)
            {
                if (group.Any(g => g.Status == "1"))
                {
                    contractInfosThatArePublished.Add(
                        new ContractInfo
                        {
                            ContractNumber = group.Key.Number,
                            Version = group.Key.Version
                        });
                }
            }


            return contractInfosThatArePublished;

            //using (var context = new ContractManagementDbContext())
            //{
            //    context.Database.Connection.ConnectionString = ConnectionString;

            //    return
            //        context.AtomFeedItems.Where(
            //            a =>
            //                a.BusinessKey.Contains(fundingTypeInfo.FundingType) &&
            //                a.CreatedDate > fundingTypeInfo.FromDate).ToList().Select(a => ContractInfo.CreateContractInfoFromKey(a.BusinessKey)).ToList();
            //}
        } 

        private IReadOnlyCollection<ContractInfo> GetContractInfosFromWorkbook(Workbook workbook, Func<Row, ContractInfo> tranformRow, string sheetName)
        {
            Worksheet workSheet = workbook.Worksheets[sheetName];
            int numRows = workSheet.Cells.GetLastDataRow(0) + 1;
            List<ContractInfo> contractInfos = new List<ContractInfo>();
            
            for (int i = 1; i < numRows; i++)
            {
                Row row = workSheet.Cells.Rows[i];
                contractInfos.Add(tranformRow(row));
            }

            return contractInfos;
        }

        private ContractInfo TransformRowToContractInfo(Row row)
        {
            return new ContractInfo
            {
                ContractNumber = row[1].StringValue.Trim(),
                Version = int.Parse(row[3].StringValue.Trim()),
                Status = row[4].StringValue.Trim()
            };
        }

        private ContractInfo TransformLiveRowToContractInfo(Row row)
        {
            ContractInfo contractInfo = ContractInfo.CreateContractInfoFromKey(row[3].StringValue.Trim());
            contractInfo.CreatedDate = TransformToUtc(row[4].DateTimeValue);
            contractInfo.Status = row[2].StringValue.Trim();

            return contractInfo;
        }

        private DateTime TransformToUtc(DateTime localDateTime)
        {
            return new DateTime(
                year: localDateTime.Year,
                month: localDateTime.Month,
                day: localDateTime.Day,
                hour: localDateTime.Hour,
                minute: localDateTime.Minute,
                second: 0,
                kind: DateTimeKind.Utc);
        }

        private static void SetupLicence()
        {
            using (Stream licenseStream = LicenseManager.GetAsposeLicense())
            {
                License license = new License();
                license.SetLicense(licenseStream);
            }
        }

        private Workbook GetWorkBook(string spreadsheetName)
        {
            using (var resource = new TestResource("SFA.FCT.ContractManagementDomain.Integration.Tests", spreadsheetName))
            {
                return new Workbook(resource.Stream);
            }
        }

        private class ContractInfo
        {
            

            public ContractInfo()
            {

            }

            public static ContractInfo CreateContractInfoFromKey(string businessKey)
            {
                int index = businessKey.IndexOf(":");
                return new ContractInfo
                {
                    ContractNumber = businessKey.Substring(0, index),
                    //int indexOfVersionSeperator = businessKey.IndexOf(".");
                    Version = int.Parse(businessKey.Substring(index + 1, 1))
                };
            }
            public string ContractNumber { get; set; }

            public int Version { get; set; }

            public string Status { get; set; }

            public DateTime CreatedDate { get; set; }

            public override int GetHashCode()
            {
                return ContractNumber.GetHashCode() ^ Version.GetHashCode();
            }

            public override bool Equals(object obj)
            {
                bool isEqual = false;
                ContractInfo other = obj as ContractInfo;
                if (other != null)
                {
                    return this.ContractNumber == other.ContractNumber &&
                        this.Version == other.Version;
                }

                return isEqual;
            }
        }

        private class FundingTypeInfo
        {
            public FundingTypeInfo(string fundingType, DateTime fromDate)
            {
                FundingType = fundingType;
                FromDate = fromDate;
            }

            public string FundingType { get; }

            public DateTime FromDate { get; }
        }
    }
}
