namespace SFA.FCT.CrossDomain.Integration.Common.Serializers
{
    public interface IByteArraySerializer
    {
        byte[] ConvertObjectToByteArray<T>(T objectToSerialize) where T : class;

        T ConvertByteArrayToObject<T>(byte[] blob) where T : class;
    }
}