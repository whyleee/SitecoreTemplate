Sitecore 7 MVC Template
=======================

Clean Sitecore 7 project template with full ASP.NET MVC 5 and NuGet support.


Features
--------

Why should I use this template?

 - **Contains clean Sitecore 7 (including [Localization](http://marketplace.sitecore.net/en/Modules/Localization_Module.aspx) and [ImageCropper](http://marketplace.sitecore.net/en/Modules/Image_Cropper.aspx) modules), with .NET 4.5.1, MVC 5 and NuGet** support. Suitable for everyone: use it as a basis for your project, for quick test website, or just for fun.
 - **Integrated into Visual Studio** as extension, which means easy install, pushed udpates and familiar experience.
 - **Fully automated project creation**: click OK and see working website in a minute. Project files, latest Sitecore files, IIS website, SQL db and access rights are all created and configured for you.
 - **Source code in on GitHub**: clone, contribute or even fork to your own template.
 - **Fully automated project template creation and package bundling**: just work with ordinary Sitecore website, and tools will create a template with all needed placeholders for you, and a package for Visual Studio gallery.


System requirements
-------------------

 - Visual Studio 2012/2013
 - .NET 4.5/4.5.1 (MVC 5 doesn't support .NET < 4.5). [Download .NET 4.5.1](http://www.microsoft.com/en-us/download/details.aspx?id=40773)
 - PowerShell 3/4 (Windows 7 has PS2, Windows 8 - PS3, Windows 8.1 - PS4). [Download PowerShell 4](http://www.microsoft.com/en-us/download/details.aspx?id=40855)
 - IIS >= 7
 - SQL Server 2008 R2 Express (SQL Server 2012 is not supported yet, because it's still not widely used). [Download SQL Server 2008 R2 SP2 Express](http://www.microsoft.com/en-us/download/details.aspx?id=30438)


Installation
------------

Install in Visual Studio by searching "Sitecore mvc" in *Tools -> Extensions and Updates...* window.

Or download extension from Visual Studio gallery.


Usage
-----

To create a new Sitecore 7 project:

1.	In Visual Studio, click *File -> New Project…*
2.	Select project type *(see notes below)*:
  1.	VS 2012: *Visual C# -> Web -> ASP.NET MVC 4 Web Application*
  2.	VS 2013: *Visual C# -> Web -> Visual Studio 2012 -> ASP.NET MVC 4 Web Application*
3.	Select .NET Framework version (only **4.5** or **4.5.1** are supported by MVC 5)
4.	Set project name and location, click OK
5.	Select `Sitecore 7` project template, click OK
6.	Select Sitecore license file to use for a site and click OK
7.	Wait a couple of minutes while project is being installed
8.	After successful project creation you'll see a new website is opened in your browser


*NOTE*: Yep, I know it's weird to select MVC 4 project type when MVC 5 is actually used. But this is due to a couple of strong reasons:
 - MVC 5 is a part of ASP.NET One reorganization, and they have totally different project template format (to support one-click Web Forms/Web API or authentication installation) which is not documented anywhere for now. And unfortunately Sitecore is not using that stuff now and in the near future.
 - Visual Studio 2012 doesn't support MVC 5 at all now, neither the new ASP.NET One project templates (they should include MVC 5 support in November 2013, let's see).


Other
-----

This project is using [vspte](https://github.com/whyleee/vspte) command-line tool to automate Visual Studio project template creation. Source code is available on [GitHub](https://github.com/whyleee/vspte).


Credits
-------

Pavel Nezhencev, 2013
