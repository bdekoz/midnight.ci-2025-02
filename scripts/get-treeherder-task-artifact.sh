#!/usr/bin/env bash

#ISODATE=`date --iso`
ISODATE=2025-02-12

XITERATION=$MOZPERFAX/bin/moz-perf-x-extract.browsertime_iteration.exe
XURLMIN=$MOZPERFAX/bin/moz-perf-x-transform-url.exe

SITELIST=sitelist.txt

CHROMEDIR=chrome
FIREFOXDIR=firefox
mkdir $CHROMEDIR
mkdir $FIREFOXDIR

get_artifact_and_unpack() {
    PLATFORM="$1"
    TESTNAME="$2"
    BROWSER="$3"
    TASKID="$4"

    # ARTIFACT=browsertime-results.tgz
    ARTIFACT=browsertime-videos-original
    ARTIFACT_URL="https://firefox-ci-tc.services.mozilla.com/api/queue/v1/task/${TASKID}/runs/0/artifacts/public/test_info/${ARTIFACT}.tgz"

    #curl --fail --silent --show-error "${ARTIFACT_URL}" --output "$ARTIFACTF";
    wget "${ARTIFACT_URL}"
    if [ ! -e "${ARTIFACT}.tgz" ]; then
	echo "cannot find artifact for $TESTNAME, skipping"
	return 1
    fi
    tar xfz ${ARTIFACT}.tgz

    # find browsertime result json file
    ARTIFACT1_NAME=cold-browsertime.json
    ARTIFACT1=`find ./$ARTIFACT -type f -name $ARTIFACT1_NAME`

    URL=`cat ${ARTIFACT1} | jq -r '.[0].info.url'`
    echo "$URL" >> sitelist.txt
    URLM=`${XURLMIN} "$URL"`

    # select data files and copy/rename.
    ARTIFACT_BASE="${BROWSER}/${URLM}"

    ARTIFACT1_ONAME=${ARTIFACT_BASE}-${ARTIFACT1_NAME};
    cp ${ARTIFACT1} ./${ARTIFACT1_ONAME};

    # use it to select iteration to use for rest of extraction.
    # Note browsertime numbering starts at 0, artifact numbering starts at 1
    ITER=`$XITERATION ./${ARTIFACT1_ONAME}`
    ITER=$((ITER + 1))

    # find video file.
    ARTIFACT2_NAME=${ITER}-original.mp4
    ARTIFACT2=`find ./$ARTIFACT -type f -name $ARTIFACT2_NAME | grep cold`
    cp ${ARTIFACT2} ./${ARTIFACT_BASE}.mp4;

    # make json file with video file, iteration info
    VOFILE=${ARTIFACT_BASE}-"video.json"
    echo '{' >> $VOFILE
    str1='"file": "XXFILE",'
    echo ${str1/XXFILE/${ARTIFACT_BASE}.mp4} >> $VOFILE
    str2='"iteration": "XXITER"'
    echo ${str2/XXITER/${ITER}} >> $VOFILE
    echo "}" >> $VOFILE

    #rm -rf ${ARTIFACT} ${ARTIFACT}.tgz

    rm -rf ${ARTIFACT}
    mv ${ARTIFACT}.tgz ${ARTIFACT_BASE}-${ARTIFACT}.tgz
}

TPMETADATA1="linux-18"
TPMETADATA2="windows-11"

# 2025-02-12
# revision 11a45cb6835c49c696ef4ff610c42af1e47e7a1b tier 3 Btime-ChR
get_artifact_and_unpack "$TPMETADATA1" "amazon" "chrome" "VBDIwrHpS3GeTKJQXGD_vQ"
get_artifact_and_unpack "$TPMETADATA1" "bing" "chrome" "fsU0VxMgTEu4N_FC_mSuxg"
get_artifact_and_unpack "$TPMETADATA1" "cnn" "chrome" "XqH_9PGhSYSdoMBHQuuM5Q"
get_artifact_and_unpack "$TPMETADATA1" "fandom" "chrome" "Yk35WLZBRE6aOZ92PeH5pg"
get_artifact_and_unpack "$TPMETADATA1" "gslides" "chrome" "azSzTromRVSN9rrE8Xo6DQ"
get_artifact_and_unpack "$TPMETADATA1" "instagram" "chrome" "Sdh-GeRVTvyy2BdnsVq-IQ"
get_artifact_and_unpack "$TPMETADATA1" "twitter" "chrome" "BntVaDgBSqeA4W690pNr-g"
get_artifact_and_unpack "$TPMETADATA1" "wikipedia" "chrome" "EUu6kCT_R_2X4UXmuOJoTg"
get_artifact_and_unpack "$TPMETADATA1" "yahoo-mail" "chrome" "EBebKMB3SiKmosxET_V0_w"


#get_artifact_and_unpack "$TPMETADATA2" "amazon" "chrome" "DtkJjosISVOvQ6WSi8aVgQ"
#get_artifact_and_unpack "$TPMETADATA2" "bing" "chrome" "Y5z6H7gjRO2EAW5hAbpi_g"
#get_artifact_and_unpack "$TPMETADATA2" "cnn" "chrome" "Yc0Zh8eNQsmEf3MBXoka4Q"
#get_artifact_and_unpack "$TPMETADATA2" "fandom" "chrome" "B4pOEVqfT2-HHS_TMw63LA"
#get_artifact_and_unpack "$TPMETADATA2" "gslides" "chrome" "D8Ss5TzUQxqLHoXG5UYtFA"
#get_artifact_and_unpack "$TPMETADATA2" "instagram" "chrome" "Nm0SlVWCRISkRNx3N8m8fQ"
#get_artifact_and_unpack "$TPMETADATA2" "twitter" "chrome" "HnbzTzDHQliTRW6tkv7isA"
#get_artifact_and_unpack "$TPMETADATA2" "wikipedia" "chrome" "Uw4J88yiSiaLaVf6rTqPqg"
#get_artifact_and_unpack "$TPMETADATA2" "yahoo-mail" "chrome" "ZaRRx1_aTE2oy11NWlbQ3A"



# 2025-02-12
# revision 67ec343f7371867197cf934cb798dd9bb4630bd2 tier 1 Btime
get_artifact_and_unpack "$TPMETADATA1" "amazon" "firefox" "Uy8PS7nOQ3-dUWfC3Vdv1A"
get_artifact_and_unpack "$TPMETADATA1" "bing" "firefox" "IBWPKBKfTtSLIOs2oBgU4w"
get_artifact_and_unpack "$TPMETADATA1" "cnn" "firefox" "VCssIb2FQmGVU-lqKU9KQg"
get_artifact_and_unpack "$TPMETADATA1" "fandom" "firefox" "D2NWCm0kST-_IqhUQW8NxQ"
get_artifact_and_unpack "$TPMETADATA1" "gslides" "firefox" "LlDVODvAQyW04IU4TZJieg"
get_artifact_and_unpack "$TPMETADATA1" "instagram" "firefox" "M4gpa1qJQJOgrrgztXY7jQ"
get_artifact_and_unpack "$TPMETADATA1" "twitter" "firefox" "NiUvBT_jSd-_YFiBhTouyQ"
get_artifact_and_unpack "$TPMETADATA1" "wikipedia" "firefox" "fTVGt7tES4CinGrrBponvw"
get_artifact_and_unpack "$TPMETADATA1" "yahoo-mail" "firefox" "PS8IMyXwTwqdtvZ2Zp_rqg"


#get_artifact_and_unpack "$TPMETADATA2" "amazon" "firefox" "Noa19AsHTVCAw4krJxwuNQ"
#get_artifact_and_unpack "$TPMETADATA2" "bing" "firefox" "N7Guq1KUSf-1395Wv0hrQw"
#get_artifact_and_unpack "$TPMETADATA2" "cnn" "firefox" "Z19NyQmcRLm-UknErMeFtw"
#get_artifact_and_unpack "$TPMETADATA2" "fandom" "firefox" "XhuaOS71SFy5pBe9o7VlIw"
#get_artifact_and_unpack "$TPMETADATA2" "gslides" "firefox" "cAjKLOZHSjiNvA91jL2sMw"
#get_artifact_and_unpack "$TPMETADATA2" "instagram" "firefox" "PQGCETH8SAC7UBOxbAQL8Q"
#get_artifact_and_unpack "$TPMETADATA2" "twitter" "firefox" "H36XeA7JTtOyf2j0tQI6DA"
#get_artifact_and_unpack "$TPMETADATA2" "wikipedia" "firefox" "anFrJ_UbQBeRYgN5fro_3g"
#get_artifact_and_unpack "$TPMETADATA2" "yahoo-mail" "firefox" "GZ28B_ymR9qkitiB-jpTsg"
