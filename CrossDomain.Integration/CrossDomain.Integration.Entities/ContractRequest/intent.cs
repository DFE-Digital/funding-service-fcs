namespace SFA.FCT.CrossDomain.Integration.Entities.ContractRequest
{
    using System;
    using System.Diagnostics.CodeAnalysis;
    using System.Xml.Serialization;

    [Serializable]
    [XmlType(Namespace = "contractrequest")]
    [XmlRoot(Namespace = "contractrequest", IsNullable = false)]
    [SuppressMessage("ReSharper", "InconsistentNaming")]
    public enum Intent
    {
        New,

        [XmlEnum("Update Draft")]
        UpdateDraft,

        [XmlEnum("Delete Draft")]
        DeleteDraft,

        Amendment,

        [XmlEnum("Update Draft Amendment")]
        UpdateDraftAmendment,

        [XmlEnum("Delete Draft Amendment")]
        DeleteDraftAmendment,

        [XmlEnum("New Amendment")]
        NewAmendment,

        [XmlEnum("Revised New")]
        RevisedNew
    }

    public static class IntentExtensions
    {
        public static bool IsNewOrNewAmendment(this Intent intent)
        {
            return intent == Intent.NewAmendment || intent == Intent.New;
        }
    }
}