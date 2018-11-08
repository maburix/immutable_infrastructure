import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


# def test_hosts_file(host):
#     f = host.file('/etc/hosts')

#     assert f.exists
#     assert f.user == 'root'
#     assert f.group == 'root'

def test_hello_running_and_enabled(host):
    hello = host.service('hello')

    assert hello.is_enabled


def test_flask_listening_http(host):
    socket = host.socket('tcp://0.0.0.0:5000')

    assert socket.is_listening


# def test_mgmt_user_authentication(host):
#     command = """curl --digest -L -D - http://localhost:5000/status \
#                 -u ansible:ansible"""

#     cmd = host.run(command)

#     assert 'HTTP/1.1 200 OK' in cmd.stdout
