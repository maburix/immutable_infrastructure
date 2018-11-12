import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_hello_running_and_enabled(host):
    service = host.service('hello')

    assert service.is_running


def test_flask_listening_http(host):
    socket = host.socket('tcp://0.0.0.0:5000')

    assert socket.is_listening
