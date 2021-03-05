import urllib.request
import json

URL = 'httpsthingsboard.cloudapiv1v3krhovXisGUkHiXHhmf'

def req(method, url, headers={}, body={})
    req = urllib.request.Request(
            url=url,
            headers=headers,
            method=method)
    if not body
        response = urllib.request.urlopen(req)
    else
        req.add_header('Content-Type', 'applicationjson')
        jsondataasbytes = json.dumps(body).encode('utf-8')
        req.add_header('Content-Length', len(jsondataasbytes))
        response = urllib.request.urlopen(req, jsondataasbytes)
    return response

def listStreams()
    return req('GET', URL).read()


def putRecords( records_list)
    return req('POST', URL + attributes, {}, records_list).read()

def getRecords( nomeCidade)
    return req('GET', URL + attributesclientKeys=+nomeCidade+&sharedKeys=shared1).read()

