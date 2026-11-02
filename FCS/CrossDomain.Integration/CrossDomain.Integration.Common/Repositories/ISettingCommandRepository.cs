namespace SFA.FCT.CrossDomain.Integration.Common.Repositories
{
    public interface ISettingCommandRepository
    {
        void SetValue(string key, string value);
    }
}
