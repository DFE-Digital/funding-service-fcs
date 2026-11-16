namespace SFA.FCT.CrossDomain.Integration.Entities.CorporateContract
{
    using System.Collections.Generic;
    using Extensions;

    public partial class Contractor
    {
        public string GetLegalAddressCsv()
        {
            IList<string> addressItems = new List<string>();
            addressItems.AddIfHasValue(addressLine1);
            addressItems.AddIfHasValue(addressLine2);
            addressItems.AddIfHasValue(addressLine3);
            addressItems.AddIfHasValue(addressLine4);
            addressItems.AddIfHasValue(town);
            addressItems.AddIfHasValue(county);
            addressItems.AddIfHasValue(postcode);

            return string.Join(", ", addressItems);
        }
    }
}
