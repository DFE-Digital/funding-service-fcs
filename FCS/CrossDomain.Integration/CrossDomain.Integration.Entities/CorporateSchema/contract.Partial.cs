namespace SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract
{
    using System;
    using System.Diagnostics.CodeAnalysis;
    using System.Globalization;
    using System.Linq;

    [SuppressMessage("StyleCop.CSharp.NamingRules", "SA1300:ElementMustBeginWithUpperCaseLetter", Justification = "as per schema")]
    public partial class contract
    {
        public override string ToString()
        {
            if (contractor != null
                && contracts != null && contracts.Count == 1)
            {
                contractType contract = contracts.First();

                if (!string.IsNullOrEmpty(contract.contractNumber))
                {
                    const string format = "{{UKPRN: {0}, contractNumber: {1}, version: {2}}}";
                    return string.Format(CultureInfo.InvariantCulture, format, contractor.ukprn, contract.contractNumber, contract.contractVersionNumber);
                }
            }

            return base.ToString();
        }

        public string GetFirstContractNumber()
        {
            if (contracts == null || contracts.Count != 1)
                return base.ToString();

            contractType contract = contracts.First();

            if (!string.IsNullOrEmpty(contract.contractNumber))
            {
                return  $"{contract.contractNumber}:{contract.contractVersionNumber}.{contract.contractSubVersionNumber}";
            }

            return base.ToString();
        }

        public DateTime? GetFirstContractApprovalDate()
        {
            DateTime? approvalDate = null;
            if (contracts != null && contracts.Count == 1)
            {
                contractType contract = contracts.First();
                approvalDate = contract.ContractApprovalDate;

            }

            return approvalDate;
        }
    }
}