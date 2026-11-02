namespace SFA.FCT.CrossDomain.Integration.Entities.CorporateContract
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics.CodeAnalysis;
    using System.Globalization;
    using System.Linq;

    [SuppressMessage("StyleCop.CSharp.NamingRules", "SA1300:ElementMustBeginWithUpperCaseLetter")]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.0.30319.34230")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "urn:sfa:schemas:contract")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "urn:sfa:schemas:contract", IsNullable = true)]
    public class ExtendedContractType : contractType
    {
        private List<ExtendedContractAllocation> _allocations;
        public decimal? ValueVariation { get; set; }

        public Guid? Id { get; set; }

        //public CrmEntityOwner Owner { get; set; }

        //public Guid? ContractAdvisorId { get; set; }

        //public Guid? PreviousVersionId { get; set; }

        //public Guid? ParentContractId { get; set; }

        public ExtendedContractType ChildContract() => contracts?.FirstOrDefault();

        [System.Xml.Serialization.XmlArrayAttribute(Order = 4)]
        [System.Xml.Serialization.XmlArrayItemAttribute("contractAllocation", IsNullable = false)]
        new public List<ExtendedContractAllocation> contractAllocations
        {
            get
            {
                _allocations = _allocations ?? new List<ExtendedContractAllocation>();
                return _allocations ;
            }
            set => _allocations = value;
        }

        [System.Xml.Serialization.XmlArrayAttribute(Order = 0)]
        [System.Xml.Serialization.XmlArrayItemAttribute("contract", IsNullable = false)]

        // ReSharper disable once InconsistentNaming
        new public List<ExtendedContractType> contracts { get; set; }

        public override string ToString()
        {
            const string format = "{{UKPRN: {0}, contractNumber: {1}, version: {2}, contracts: {3}}}";

            string childContracts = "[";
            string separator = string.Empty;
            foreach (var childContract in contracts)
            {
                childContracts += string.Format("{0}\"{1}-v{2}\"", separator, childContract.contractNumber, childContract.contractVersionNumber);
                separator = ", ";
            }

            childContracts += "]";

            return string.Format(CultureInfo.InvariantCulture, format, contractor.ukprn, contractNumber, contractVersionNumber, childContracts);
        }

        public void CopyTerminationDetailsToProvisionalFields()
        {
            InflightStopNewStartsDate = StopNewStartsDate;
            InflightNewStartsSuspendedReason = NewStartsSuspendedReason;
            InflightTerminationDate = TerminationDate;
            InflightTerminationReason = TerminationReason;
            contractAllocations.ForEach(a =>
            {
                a.InflightStopNewStartsDate = a.StopNewStartsDate;
                a.InflightNewStartsSuspendedReason = a.NewStartsSuspendedReason;
                a.InflightTerminationDate = a.FundingCessationDate;
            });
        }
    }
}
