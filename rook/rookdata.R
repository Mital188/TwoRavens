##
##  rookdata.R
##
##  3/3/15
##



data.app <- function(env){

    ## Define paths for output.
    ## Also set `production` toggle:  TRUE - Production, FALSE - Local Development.
    source("rookconfig.R") 

    warning<-FALSE
    result <- list()

    if(production){
        sink(file = stderr(), type = "output")
    }

    request <- Request$new(env)
    response <- Response$new(headers = list( "Access-Control-Allow-Origin"="*"))

    valid <- jsonlite::validate(request$POST()$solaJSON)
    print(valid)
    if(!valid) {
        warning <- TRUE
        result <- list(warning="The request is not valid json. Check for special characters.")
    }

    if(!warning) {
        everything <- jsonlite::fromJSON(request$POST()$solaJSON)
        print(everything)
    }

  if(!warning){
      dataurl=everything$zdataurl
      if(length(dataurl) == 0){
          warning <- TRUE
          result<-list(warning="No dataverse URL.")
      }
  }
    if(!warning){
      dataname=everything$zdata
      print(dataname)
      index=regexpr(pattern='\\.',dataname)
      datanm=substr(dataname,1,index-1)
      # print()
      metadataurl=everything$zmetadataurl
      if(length(metadataurl)==0)
      {metadataurl=NULL}
      username=everything$zusername
      if(length(username)==0)
      {username=NULL}
      else{

        mainDir<-"../users"
        subDir<-username
        #create a new directory for the particular user if it doesnt exist
        if(!dir.exists(file.path(mainDir, subDir)))
        {

          dir.create(file.path(mainDir, subDir))
        }

        #print("metadataurl")
        #print(metadataurl)
        #print("Username")
        #print(username)
      }
      config=list(metadata=metadataurl,user=username,data=datanm)
      outconfig=rjson::toJSON(config)
      write(outconfig,file="config.json")
    }
  if(!warning){
      datacite=everything$zdatacite
      if(length(datacite) == 0){
          warning <- TRUE
          result<-list(warning="No data file citation.")
      }
  }



  if(!warning){

          # this will generate a unique id on the system for Mac/Unix. Might need something else for other systems. getData() is called by rookdata.R, which is the app that is called when TwoRavens is loaded (the "Explore" button is clicked). This downloads the data in the background to /tmp/ while the user is specifying a model. /tmp/ will be wiped every so often or after inactivity.

          # See if an ID exists; django layer may try to pass an initial id
          myid=everything$zsessionid
          if(length(myid)==0){
            # no id? then generate one using uuid
            myid <- system("uuidgen",intern=T)
          }
          logfile<-logFile(myid, production)
          logSessionInfo(logfile, myid, datacite)

          # We discovered that R's read.delim() method does not work with https URLs.
          # So I worked around it with the hack below - I first download the tab-delimited file and
          # save it locally, using download.file() method; then read the local file with read.delim.
          # If anyone knows of a prettier way of doing this - please change it accordingly...
          # -- L.A.
          #mydata<-tryCatch(expr=read.delim(file=dataurl), error=function(e) NULL)  # if data is not readable, NULL
          if(production) {
              tryCatch({
                  dataurl.NoAPIToken<-sub("?key=.*$", "key=", dataurl )  # Truncate the dataurl at "key=" to avoid copying any Sword APIToken
                  if(!identical(dataurl,dataurl.NoAPIToken)){
                      write("A Dataverse API token has been removed from the file URL provided to keep your Dataverse login secure.\nIf this Dataverse has restricted access you will need to append a valid API token for this replication file to work automatically.\nSee http://guides.dataverse.org/en/latest/api/index.html \n",logfile,append=TRUE)
                  }
                  download.file(dataurl,destfile = paste("/tmp/data_",myid,".tab",sep=""),method="curl",extra=c("--insecure"))
                  write(deparse(bquote(download.file(.(dataurl.NoAPIToken),destfile = .(paste("data_",myid,".tab",sep="")),method="curl",extra=c("--insecure")))),logfile,append=TRUE)
                  result <- list(sessionid=myid)
              }, error=function(e) {
                  result <<- list(warning="Error: Cannot download from Dataverse.") # if the url is not readable, NULL
              })
          } else {
              result <- list(sessionid=myid)
          }
  }

    print(result)
    if(production){
        sink()
    }

    result<-jsonlite:::toJSON(result)

    response$write(result)
    response$finish()
}
