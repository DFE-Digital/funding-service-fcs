namespace FCT.Console.Config.DocumentFolders
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;

    public static class DocumentFolderNameUtility
    {
        private static readonly IReadOnlyCollection<DocumentSuffix> DocumentSuffixes = new List<DocumentSuffix>
        {
            new DocumentSuffix("Input-Appendices", true),
            new DocumentSuffix("Input-Terms And Conditions", false),
            new DocumentSuffix("Output-Documents for Publication", true),
            new DocumentSuffix("Output-Merged Document", false),
        };

        public static IReadOnlyCollection<string> GetFolderNames(bool shouldCreateFoldersPastActivityCloseDate)
        {
            using (var context = new ContractManagementDbContext())
            {
                Func<FundingTypeFundingPeriod, bool> contractingActivityCloseDateFilter =
                    GetContractingActivityCloseDateFilter(shouldCreateFoldersPastActivityCloseDate);

                IReadOnlyCollection<FundingTypeFundingPeriod> relevantFtps =
                    context.FundingTypeFundingPeriodItems.Where(
                        ftp => ftp.DocumentsRequired).ToList();

                return relevantFtps
                    .Where(contractingActivityCloseDateFilter)
                    .SelectMany(ftp =>
                    GetRelevantSuffixes(ftp).Select(s =>
                        $"{GetFolderPrefix(ftp)}-{s.Suffix}")).ToList();
            }
        }

        private static string GetFolderPrefix(FundingTypeFundingPeriod fundingTypePeriod)
        {
            string fpName = fundingTypePeriod.FundingPeriodName;
            string period = fpName.Substring(fpName.Length - 4);
            return $"{fundingTypePeriod.FundingTypeCode}-{period}";
        }

        private static IReadOnlyCollection<DocumentSuffix> GetRelevantSuffixes(FundingTypeFundingPeriod ftp)
        {
            List<DocumentSuffix> suffixes = DocumentSuffixes.ToList();

            if (ftp.SkipDocumentMerge)
            {
                suffixes = DocumentSuffixes.Where(s => s.RequiredIfSkipDocMerge).ToList();
            }

            return suffixes;
        }

        private static Func<FundingTypeFundingPeriod, bool> GetContractingActivityCloseDateFilter(bool shouldCreateFoldersPastActivityCloseDate)
        {
            Func<FundingTypeFundingPeriod, bool> filter = ftp => true;

            if (!shouldCreateFoldersPastActivityCloseDate)
            {
                DateTime today = DateTime.UtcNow.Date;

                filter = ftp =>
                    !ftp.ContractingActivityCloseDate.HasValue || ftp.ContractingActivityCloseDate >= today;
            }

            return filter;
        }

        private class DocumentSuffix
        {
            public DocumentSuffix(string suffix, bool requiredIfSkipDocMerge)
            {
                Suffix = suffix;
                RequiredIfSkipDocMerge = requiredIfSkipDocMerge;
            }

            public string Suffix { get; }

            public bool RequiredIfSkipDocMerge { get; }
        }
    }
}