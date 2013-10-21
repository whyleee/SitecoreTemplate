using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SitecoreTemplate.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            ViewBag.Title = Sitecore.Context.Item["Title"];
            ViewBag.Message = new HtmlString(Sitecore.Context.Item["Text"]);

            return PartialView();
        }
    }
}
