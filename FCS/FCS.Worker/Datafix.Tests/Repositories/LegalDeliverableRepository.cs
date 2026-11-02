namespace Datafix.Tests.Repositories
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using ContractManagement.DataStore.Model;
    using Newtonsoft.Json.Linq;

    public static class LegalDeliverableRepository
    {
        private static ILookup<string, FundingStreamPeriodLegalDeliverable> _fspDeliverables = null;

        public static IReadOnlyCollection<FundingStreamPeriodLegalDeliverable> GetLegalDeliverablesForFsp(
            string fspCode)
        {
            if (_fspDeliverables == null)
            {
                using (Stream stream = Assembly.GetCallingAssembly()
                    .GetManifestResourceStream($"Datafix.Tests.Resources.Config.json"))
                {
                    JObject parentJObject = JObject.Parse(new StreamReader(stream).ReadToEnd());
                    JArray fspDeliverables = parentJObject["FSP Deliverables"] as JArray;
                    _fspDeliverables = fspDeliverables.Select(ToFundingStreamPeriodLegalDeliverable)
                        .Where(d => d != null)
                        .ToLookup(d => d.FundingStreamPeriodCode);
                }
            }

            return _fspDeliverables[fspCode].ToList();
        }

        private static FundingStreamPeriodLegalDeliverable ToFundingStreamPeriodLegalDeliverable(JToken deliverableJson)
        {
            string fspCode = deliverableJson["FundingStreamPeriodCode"].ToString();
            int deliverableCode = int.Parse(deliverableJson["DeliverableCode"].ToString());
            string name = deliverableJson["DeliverableName"].ToString();
            bool isMandatory = deliverableJson["Mandatory"].ToString() == "Mandatory";
            bool approved = int.Parse(deliverableJson["PolicyStatus"].ToString()) == 0;

            if (isMandatory && approved)
            {
                return new FundingStreamPeriodLegalDeliverable(fspCode, deliverableCode, true, name, 1);
            }

            return null;
        }
    }
}
