namespace SFA.FCS.Worker.Common
{
    public interface IFcsConfiguration
    {
        string this[string key] { get; }
    }
}
