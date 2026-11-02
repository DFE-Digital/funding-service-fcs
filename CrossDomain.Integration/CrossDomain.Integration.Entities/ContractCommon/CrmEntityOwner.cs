namespace SFA.FCT.CrossDomain.Integration.Entities
{
    using System;
    using System.Xml.Serialization;

    public enum OwnerType
    {
        SystemUser,
        Team
    }

    [Serializable]
    public class CrmEntityOwner
    {
        [XmlIgnore]
        public Guid? OwnerId { get; set; }

        [XmlIgnore]
        public OwnerType? OwnerType { get; set; }
    }
}