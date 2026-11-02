namespace ADMonitoringDomain.DataStore
{
    public interface ISerializeToType
    {
        object Object { get; set; }

        string ObjectType { get; set; }

        string SerializedXml { get; set; }
    }
}
