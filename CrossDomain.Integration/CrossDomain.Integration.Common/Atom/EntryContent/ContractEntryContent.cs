namespace SFA.FCT.CrossDomain.Integration.Common.Atom.EntryContent
{
    using System.Diagnostics.CodeAnalysis;
    using System.Xml.Serialization;
    using Entities.CorporateSchema.Contract;

    [SuppressMessage("StyleCop.CSharp.NamingRules", "SA1300:ElementMustBeginWithUpperCaseLetter")]
    [XmlRoot(Namespace = "urn:sfa:schemas:contract", IsNullable = false)]
    public class ContractEntryContent : IEntryContent<contract>
    {
        // ReSharper disable once InconsistentNaming
        public contract contract { get; set; }

        public void SetRootProperty(contract value)
        {
            contract = value;
        }
    }
}
