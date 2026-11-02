namespace SFA.FCT.CrossDomain.Integration.Entities
{
    public class CrmContractIdentity
    {
        public CrmContractIdentity(string number, int version, int subVersion, string crmEntityId)
        {
            Number = number;
            Version = version;
            SubVersion = subVersion;
            CrmEntityId = crmEntityId;
        }

        public string Number { get; }
        public int Version { get; }
        public int SubVersion { get; }
        public string CrmEntityId { get; }

        public override string ToString()
        {
            return $"Number: {Number}, Version: {Version}, SubVersion: {SubVersion}, CrmEntityId: {CrmEntityId}";
        }
    }
}
