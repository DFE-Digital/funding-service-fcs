namespace SFA.FCT.CrossDomain.Integration.Common.Repositories
{
    using System.Data.Entity;

    public interface ISettingContext<T> where T : class
    {
        IDbSet<T> Settings { get; }

        int SaveChanges();
    }
}
