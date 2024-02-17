using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.StaticFiles;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using web_api.Models;

namespace web_api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    //[RequestSizeLimit(100 * 1024 * 1024)]
    //[RequestFormLimits(MultipartBodyLengthLimit = 100 * 1024 * 1024)]
    [DisableRequestSizeLimit]
    public class FileController : ControllerBase
    {

        public FileController(IWebHostEnvironment hostingEnvironment)
        {
            _hostingEnvironment = hostingEnvironment;
        }

        public IWebHostEnvironment _hostingEnvironment { get; }


        [HttpGet]
        public ActionResult<IEnumerable<Models.File>> Get()
        {
            var fileList = Directory.GetFiles(Path.Combine(_hostingEnvironment.ContentRootPath, "App_Data"));

            var list = from file in fileList
                       let fileInfo = new FileInfo(file)
                       select new Models.File
                       {
                           FileName = fileInfo.Name,
                           DateModified = fileInfo.LastWriteTime,
                           Size = fileInfo.Length
                       };

            return Ok(list);

        }

        [HttpGet("{name}")]
        public IActionResult File_Get(string name)
        {


            if (string.IsNullOrEmpty(name))
            {
                //return Ok(_syncService.GetAllFiles("Update"));
                return NotFound();
            }


            var serverPath = _hostingEnvironment.ContentRootPath + ("/App_Data/" + name);
            var fileInfo = new FileInfo(serverPath);


            if (!System.IO.File.Exists(serverPath))
            {
                return NotFound();
            }

            string contentType;
            new FileExtensionContentTypeProvider().TryGetContentType(serverPath, out contentType);

            //return base.PhysicalFile(serverPath, new MediaTypeHeaderValue(contentType).MediaType);
            return base.PhysicalFile(serverPath, "application/octet-stream");

        }


        [HttpPost]
        public async Task<ActionResult> Post(IFormFile File)
        {

            var httpRequest = Request;

            var isForm = false;
            
            if (httpRequest.ContentType.ToLower().Contains("multipart/form-data"))
            {
                isForm = true;
            }

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (isForm && httpRequest.Form.Files.Count > 0)
            {
                foreach (var oUploadFile in httpRequest.Form.Files)
                {
                    var postedFile = oUploadFile;

                    var fileName = oUploadFile.FileName;

                    var filePath = _hostingEnvironment.ContentRootPath + ("/App_Data/" + fileName);

                    try
                    {
                        using (var fileStream = new FileStream(filePath, FileMode.Create))
                        {
                            await oUploadFile.CopyToAsync(fileStream);
                        }
                    }
                    catch (Exception ex)
                    {

                        System.Diagnostics.Debug.WriteLine(ex.Message);
                    }
                }

                return Created("", "");
            }
            else
            {
                var stream = Request.Body;

                var filename = Request.Headers["filename"];

                var filePath = _hostingEnvironment.ContentRootPath + ("/App_Data/" + filename);

                using (var fs = new FileStream(filePath, FileMode.Create))
                {
                    stream.CopyTo(fs);
                }

                return Ok(new { status = "OK" });
            }
        }

        [HttpDelete("{name}")]
        public ActionResult Delete(string name)
        {
            var filePath = _hostingEnvironment.ContentRootPath + ("/App_Data/" + name);

            if (System.IO.File.Exists(filePath))
            {
                System.IO.File.Delete(filePath);
            }

            return Ok();
        }

        [HttpPost("upload2")]
        public async Task<IActionResult> Upload2(IFormFileCollection files)
        {
            var f = files.ToArray();
            //Array.ForEach(f, async (file) =>
            //{
            //    using var stream = file.OpenReadStream();
            //    using var newStream = new MemoryStream();
            //    await stream.CopyToAsync(newStream);
            //    await ProcessFile(newStream);
            //});
            //return RedirectLocal("UploadSuccess");

            var streams = await Task.WhenAll(f.Select(async (file) =>
            {
                using var stream = file.OpenReadStream();
                var newStream = new MemoryStream();
                await stream.CopyToAsync(newStream);
                return newStream;
            }).ToArray());

            return Ok(new { status = "OK" });
        }

    }
}