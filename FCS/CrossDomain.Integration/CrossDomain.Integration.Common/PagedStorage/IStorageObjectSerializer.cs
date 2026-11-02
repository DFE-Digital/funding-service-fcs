namespace SFA.FCT.CrossDomain.Integration.Common.PagedStorage
{
    public interface IStorageObjectSerializer
    {
        byte[] Serialize(object obj);

        T Deserialize<T>(byte[] bytes);
    }
}
