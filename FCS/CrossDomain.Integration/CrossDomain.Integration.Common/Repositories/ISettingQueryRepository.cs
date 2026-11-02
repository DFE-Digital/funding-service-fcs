namespace SFA.FCT.CrossDomain.Integration.Common.Repositories
{
    public interface ISettingQueryRepository<T>
    {
        string GetValue(string key);
    }
}
