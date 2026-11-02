namespace SFA.FCT.Operations.Integrity.Repositories
{
    public interface IIntegrityCheckChangeTrackingRepository
    {
        long GetCurrentVersion(string name);

        void Update(string name, long currentVersion);
    }
}
