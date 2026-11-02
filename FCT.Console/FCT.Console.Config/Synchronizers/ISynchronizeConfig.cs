namespace FCT.Console.Config.Synchronizers
{
    using Excel;

    public interface ISynchronizeConfig
    {
        void AddOrUpdateConfig(IWorksheetReader worksheetReader);

        void DeleteConfig(IWorksheetReader worksheetReader);
    }
}
