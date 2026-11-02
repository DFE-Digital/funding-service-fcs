namespace SFA.FCT.CrossDomain.Integration.Entities.CorporateContract
{
    using System.Collections.Generic;
    using System.Diagnostics.CodeAnalysis;
    using System.Globalization;
    using System.Linq;

    [SuppressMessage("StyleCop.CSharp.NamingRules", "SA1300:ElementMustBeginWithUpperCaseLetter", Justification = "as per schema")]
    public partial class contract
    {
        public const string ToStringFormat = "{{'UKPRN': {0}, 'contractNumber': '{1}', 'version': {2}}}";

        public override string ToString()
        {
            if (contractor != null
                && contracts != null && contracts.Count == 1)
            {
                contractType contract = contracts.First();

                if (!string.IsNullOrEmpty(contract.contractNumber))
                {
                    return string.Format(CultureInfo.InvariantCulture, ToStringFormat, contractor.ukprn, contract.contractNumber, contract.contractVersionNumber);
                }
            }
            else
            {
                return $"Child Contract - Number: {contractNumber}, Version: {contractVersionNumber}, SubVersion: {contractSubVersionNumber}";
            }

            return base.ToString();
        }

        public IReadOnlyCollection<string> GetAllocationNumbers()
        {
            return contracts.SelectMany(c => c.contractAllocations.Select(ca => ca.contractAllocationNumber)).ToList();
        }
    }
}