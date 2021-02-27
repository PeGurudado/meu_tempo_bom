import urllib.request
import json

URL = 'https://jdc9tuwgp6.execute-api.us-east-1.amazonaws.com'

def req(method, url, headers={}, body={}):
    req = urllib.request.Request(
            url=url,
            headers=headers,
            method=method)
    if not body:
        response = urllib.request.urlopen(req)
    else:
        req.add_header('Content-Type', 'application/json')
        jsondataasbytes = json.dumps(body).encode('utf-8')
        req.add_header('Content-Length', len(jsondataasbytes))
        response = urllib.request.urlopen(req, jsondataasbytes)
    return response

def listStreams():
    return req('GET', URL + '/a/streams/').read()

def createStream(stream_name):
    return req('POST', URL + '/a/streams/stream-name?pename=' + stream_name).read()

def deleteStream(stream_name):
    return req('DELETE', URL + '/a/streams/stream-name?pename=' + stream_name).read()

def putRecords(stream_name, key_name, records_list):
    records = []
    for record in records_list:
        records.append({'partition-key':key_name, 'data': record})
    return req('PUT', URL + '/a/streams/stream-name/records?pename=' + stream_name, {}, {"records":records}).read()

def getShardId(stream_name):
    return req('GET', URL + '/a/streams/stream-name/?pename=' + stream_name).read()

def getShardIterator(stream_name, shard_id):
    return req('GET', URL + '/a/streams/stream-name/sharditerator?pename=' + stream_name + '&shard-id=' + shard_id).read()

def getRecords(shard_iterator):
    return req('GET', URL + '/a/streams/stream-name/records', {'Shard-Iterator': shard_iterator}).read()

