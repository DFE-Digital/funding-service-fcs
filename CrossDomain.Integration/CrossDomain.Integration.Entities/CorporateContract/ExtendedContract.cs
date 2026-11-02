namespace SFA.FCT.CrossDomain.Integration.Entities.CorporateContract
{
    using System;

    [Serializable]
    public class ExtendedContract : ExtendedContractType
    {
         private decimal schemaVersionField;

         public ExtendedContract()
        {
            this.schemaVersionField = ((decimal)(8.04m));
        }

        [System.Xml.Serialization.XmlAttributeAttribute()]
        public decimal schemaVersion
        {
            get
            {
                return this.schemaVersionField;
            }
            set
            {
                this.schemaVersionField = value;
            }
        }
    }
}
