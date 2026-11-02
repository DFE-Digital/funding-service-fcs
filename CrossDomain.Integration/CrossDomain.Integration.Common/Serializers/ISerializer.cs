namespace SFA.FCT.CrossDomain.Integration.Common.Serializers
{
    public interface ISerializer
    {
        string Serialize<T>(T source);

        T Deserialize<T>(string source);
    }
}
