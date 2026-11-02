using Microsoft.AspNetCore.Http;
using System.Threading.Tasks;

namespace FCS.Worker.Azure.Functions.Services
{
    public interface IBlobService
    {       
        Task<string> UploadFileAsync(IFormFile file, string container);
    }
}