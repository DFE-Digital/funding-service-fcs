namespace SFA.FCT.FundingStreamConfigDomain.BusinessLogic
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities;
    using Microsoft.Xrm.Sdk;

    /// <summary>
    /// DeliverableData
    /// </summary>
    internal class DeliverableData
    {
        public int DeliverableCode { get; set; }

        public string DeliverableName { get; set; }

        public string FundingStreamPeriodCode { get; set; }

        public bool HasParent { get; set; }

        public int ParentId { get; set; }

        public DeliverableParentRelationshipType ParentRelationshipType { get; set; }

        public EntityReference ParentReference { get; set; }

        public OptionSetValue ParentRelationshipOptionSetValue { get; set; }

        public IDictionary<string, string> Settings { get; set; }
    }
}