
using System.Diagnostics.CodeAnalysis;
using System.Xml.Serialization;

namespace SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation
{
    [SuppressMessage("StyleCop.CSharp.NamingRules", "SA1300:ElementMustBeginWithUpperCaseLetter",
       Justification = "as per schema")]
    public partial class deliverableType
    {
        private int _displayOrderField;

        [XmlIgnore]
        public int DisplayOrder
        {
            get { return this._displayOrderField; }
            set { this._displayOrderField = value; }
        }
    }
}
