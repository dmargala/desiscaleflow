from setuptools import setup

setup_keywords = dict(
    name='desiscaleflow',
    version='0.0.1',
    packages=['desiscaleflow'],
    install_requires=[
    ],
)

setup_keywords['scripts'] = [
    'bin/desi_scale_run',
    'bin/desi_redirect_output',
]

setup(**setup_keywords)
